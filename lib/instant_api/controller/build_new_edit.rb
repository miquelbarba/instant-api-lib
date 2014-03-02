module InstantApi::Controller
  class BuildNewEdit

    def initialize(controller, method)
      @controller = controller
      @method = method
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