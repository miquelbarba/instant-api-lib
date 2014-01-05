module InstantApi::Controller
  class BuildShow

    def initialize(controller, model_class_name = nil)
      @controller = controller
    end

    def build
      @controller.class_eval(&build_show)
    end

    private

    def build_show
      Proc.new do
        def show
          render json: resource
        end
      end
    end
  end
end