module InstantApi::Controller
  class BuildEdit

    def initialize(controller, model_class_name = nil)
      @controller = controller
    end

    def build
      @controller.class_eval(&build_edit)
    end

    private

    def build_edit
      Proc.new do
        def edit
          render json: resource
        end
      end
    end
  end
end