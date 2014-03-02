module InstantApi::Controller
  class BuildIndex

    attr_reader :model_class_name, :controller

    def initialize(controller, model_class_name)
      @controller = controller
      @model_class_name = model_class_name
    end

    def build
      methods = [build_index, build_page, build_per_page, build_collection,
                 build_paginated_collection]
      methods.each { |m| controller.class_eval(&m) }
    end

    private
    def build_index
      body = %Q{
        def index
          response = {
            collection: paginated_collection,
            pagination: {
              count: #{model_class_name}.count,
              page: page,
              per_page: per_page
            }
          }

          render json: response
        end
      }

      Proc.new { eval body }
    end

    def build_page
      Proc.new do
        def page
          @page ||= [(params[:page] || 1).to_i, 1].max
        end
        private :page
      end
    end

    def build_per_page
      Proc.new do
        def per_page
          @per_page ||= begin
            aux = (params[:per_page] || 10).to_i
            if aux < 1
              aux = 10
            end
            [aux, 10].min
          end
        end
        private :per_page
      end
    end

    def build_collection
      body = %Q{
          def collection
            @collection ||= #{model_class_name}.all
          end
          private :collection
        }
      Proc.new { eval body }
    end

    def build_paginated_collection
      Proc.new do
        def paginated_collection
          collection_to_paginate = if collection.is_a?(Array)
                                     Kaminari::paginate_array(collection)
                                   else
                                     collection
                                   end
          collection_to_paginate.page(page).per(per_page)
        end
        private :paginated_collection
      end
    end
  end
end