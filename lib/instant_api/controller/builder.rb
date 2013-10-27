require 'instant_api/controller/exception_handler'

module InstantApi::Controller
  class Builder

    attr_reader :model_name, :model_class_name,
                :method_names, :controller_class_name
    def initialize(controller_name, method_names)
      @model_class_name = controller_name.camelize.singularize
      @model_name = model_class_name.downcase
      @controller_class_name = "#{controller_name.camelize}Controller"
      @method_names = method_names
    end

    def build_class
      controller = Class.new(ApplicationController)
      controller.send(:include, InstantApi::Controller::ExceptionHandler)
      build_public_methods(controller)
      build_private_methods(controller)
      Object.const_set(@controller_class_name, controller)
    end

    private

    def build_public_methods(controller)
      build_methods(method_names, controller)
    end

    PRIVATE_METHODS = [:resource, :collection, :page, :per_page,
                       :paginated_collection, :check_strong_parameters]
    def build_private_methods(controller)
      build_methods(PRIVATE_METHODS, controller)
    end

    def build_methods(list, controller)
      list.each { |name| build_method(name, controller) }
    end

    def build_method(name, controller)
      method = send("build_#{name}")
      controller.class_eval(&method)
    end

    def build_new
      Proc.new do
        def new
          head :ok
        end
      end
    end

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

    def build_show
      Proc.new do
        def show
          render json: resource
        end
      end
    end

    def build_create
      body = %Q{
        # extract this require
        require 'instant_api/model/builder'
        def create
          resource = InstantApi::Model::Builder.new(params, #{model_class_name}, true).build
          render json: resource
        end
      }

      Proc.new { eval body }
    end

    def build_edit
      Proc.new do
        def edit
          render json: resource
        end
      end
    end

    def build_update
      Proc.new do
        def update
          resource.update_attributes!(check_strong_parameters)
          render json: resource
        end
      end
    end

    def build_destroy
      Proc.new do
        def destroy
          resource.destroy!
          render status: 200, nothing: true
        end
      end
    end

    def build_resource
      body = %Q{
        def resource
          #{model_class_name}.find(params[:id])
        end
        private :resource
      }
      Proc.new { eval body }
    end

    def build_check_strong_parameters
      body = if model_class_name.constantize.respond_to?(:strong_parameters)
        "params.require(:#{model_name}).permit(#{model_class_name}.strong_parameters)"
      else
        "params.require(:#{model_name}).permit!"
      end

      Proc.new do
        eval %Q{
          def check_strong_parameters
            #{body}
          end
          private :check_strong_parameters
        }
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
          @per_page ||= [(params[:per_page] || 10).to_i, 10].min
        end
        private :per_page
      end
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