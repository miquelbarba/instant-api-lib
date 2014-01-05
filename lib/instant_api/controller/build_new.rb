module InstantApi::Controller
  class BuildNew

    def initialize(controller, model_class_name = nil)
      @controller = controller
    end

    def build
      @controller.class_eval(&build_new)
    end

    private

    def build_new
      Proc.new do
        def new
          head :ok
        end
      end
    end
  end
end