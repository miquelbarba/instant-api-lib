module InstantApi::Controller
  class BuildCreate

    attr_reader :model_class_name, :controller

    def initialize(controller, model_class_name)
      @controller, @model_class_name = controller, model_class_name
    end

    def build
      controller.class_eval(&build_create)
    end

    private

    def build_create
      # TODO: extract this require
      body = %Q{
        require 'instant_api/model/builder'
        require 'instant_api/controller/parameters'
        def create
          parameters = InstantApi::Controller::Parameters.new(params, request.path)
          builder = InstantApi::Model::Builder.new(parameters, #{model_class_name}, true)
          render json: builder.build
        end
      }

      Proc.new { eval body }
    end
  end
end