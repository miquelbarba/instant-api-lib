module InstantApi::Controller
  class BuildResource
    def initialize(controller, model_class_name)
      @controller, @model_class_name = controller, model_class_name
    end

    def build
      @controller.class_eval(&build_resource)
    end

    private

    def build_resource
      # TODO: extract this require
      body = %Q{
        require 'instant_api/model/resource'
        def resource
          @resource ||= begin
            parameters = InstantApi::Controller::Parameters.new(params, request.path)
            InstantApi::Model::Resource.new(#{@model_class_name}, parameters).find
          end
        end
        private :resource
      }
      Proc.new { eval body }
    end
  end
end