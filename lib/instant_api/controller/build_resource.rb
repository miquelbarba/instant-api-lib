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
      # TODO: extract this require
      body = %Q{
        require 'instant_api/model/resource'
        def resource
          InstantApi::Model::Resource.new(#{model_class_name}, request.path, params).find
        end
        private :resource
      }
      Proc.new { eval body }
    end
  end
end