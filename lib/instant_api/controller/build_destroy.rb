module InstantApi::Controller
  class BuildDestroy

    def initialize(controller, model_class_name = nil)
      @controller = controller
    end

    def build
      @controller.class_eval(&build_destroy)
    end

    private

    def build_destroy
      Proc.new do
        def destroy
          resource.destroy!
          render status: 200, nothing: true
        end
      end
    end
  end
end