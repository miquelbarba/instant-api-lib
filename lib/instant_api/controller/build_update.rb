module InstantApi::Controller
  class BuildUpdate

    attr_reader :model_class_name, :model_name, :controller

    def initialize(controller, model_class_name)
      @controller = controller
      @model_class_name = model_class_name
      @model_name = model_class_name.underscore
    end

    def build
      controller.class_eval(&build_update)
      controller.class_eval(&build_check_strong_parameters)
    end

    private

    def build_update
      Proc.new do
        def update
          resource.update_attributes!(check_strong_parameters)
          render json: resource
        end
      end
    end

    def build_check_strong_parameters
      body = if model_class_name.constantize.respond_to?(:strong_parameters)
               "params.require(:#{model_name}).permit(#{model_class_name}.strong_parameters)"
             else
               "params.require(:#{model_name}).permit!"
             end

      Proc.new do
        eval %Q{
          def check_strong_parameters
            #{body}
          end
          private :check_strong_parameters
        }
      end
    end
  end
end