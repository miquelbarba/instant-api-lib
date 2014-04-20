module InstantApi::Controller
  class BuildIndex

    attr_reader :model_class_name, :controller

    def initialize(controller, model_class_name)
      @controller = controller
      @model_class_name = model_class_name
    end

    def build
      controller.class_eval(&build_index)
    end

    private
    def build_index
      body = %Q{
        require 'instant_api/model/collection'
        require 'instant_api/controller/parameters'
        def index
          parameters = InstantApi::Controller::Parameters.new(params, request.path)
          collection = InstantApi::Model::Collection.new(#{model_class_name}, parameters)
          response = {
            collection: collection.paginated_collection,
            pagination: {
              count: collection.count,
              page: collection.page,
              per_page: collection.per_page
            }
          }

          render json: response
        end
      }

      Proc.new { eval body }
    end
  end
end