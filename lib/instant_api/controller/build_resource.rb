module InstantApi::Controller
  class BuildResource

    attr_reader :model_class_name, :controller

    def initialize(controller, model_class_name)
      @controller, @model_class_name = controller, model_class_name
    end

    def build
      controller.class_eval(&build_resource)
    end

    private

    def build_resource
      body = %Q{
        def resource
          #{model_class_name}.find(params[:id])
        end
        private :resource
      }
      Proc.new { eval body }
    end
  end
end