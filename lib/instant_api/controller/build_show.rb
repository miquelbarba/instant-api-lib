module InstantApi::Controller
  class BuildShow

    def initialize(controller, model_class_name = nil)
      @controller = controller
      @method = 'show'
    end

    def build
      @controller.class_eval(&build_method)
    end

    private

    def build_method
      body = %Q{
        def #{@method}
          render json: resource
        end
      }

      Proc.new { eval body }
    end
  end
end