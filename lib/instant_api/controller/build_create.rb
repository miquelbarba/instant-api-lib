module InstantApi::Controller
  class BuildCreate

    attr_reader :model_class_name, :controller

    def initialize(controller, model_class_name)
      @controller = controller
      @model_class_name = model_class_name
    end

    def build
      controller.class_eval(&build_create)
    end

    private

    def build_create
      # TODO: extract this require
      body = %Q{
        require 'instant_api/model/builder'
        def create
          resource = InstantApi::Model::Builder.new(params, #{model_class_name}, true).build
          render json: resource
        end
      }

      Proc.new { eval body }
    end
  end
end