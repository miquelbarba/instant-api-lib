module InstantApi::Model
  class Resource
    attr_reader :klass, :request_path, :params

    def initialize(klass, request_path, params)
      @klass, @request_path, @params = klass, request_path, params
    end

    def find
      if single_resource?(request_path)
        single_resource(klass, params)
      else
        multiple_resource(klass, params, request_path)
      end
    end


    private

    def single_resource?(url)
      resources(url).size == 1
    end

    def single_resource(klass, params)
      klass.find(params[:id])
    end

    def multiple_resource(klass, params, url)
      result = klass.joins(build_joins(url)).where(build_params(url, params)).first
      raise ActiveRecord::RecordNotFound.new if !result
      result
    end

    def build_joins(url)
      head, *rest, _ = *resources(url)
      [head.to_s.singularize.to_sym] + rest
    end

    def build_params(url, params)
      result = { id: params[:id] }

      resource, *rest = *resources(url)
      klass = to_class(resource)
      rest.map do |association_name|
        if (assoc = association(klass, association_name))
          table = association_table(assoc)
          result[table] = { assoc.primary_key_name => params[assoc.primary_key_name] }
        end

        resource = association_name
        klass = to_class(resource)
      end

      result
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
    end

    def association_table(assoc)
      assoc.options[:join_table] || assoc.name
    end

    def association(klass, name)
      klass.reflect_on_all_associations.select { |assoc| assoc.name == name }.first
    end

    def resources(url)
      @resources ||= begin
        resources = url.split('/').each_with_index.
                        select { |_, index| index % 2 == 1 }.
                        map { |a, _| a.to_sym }

        *rest, tail = *resources
        if tail == :edit || tail == :new
          rest
        else
          resources
        end
      end
    end
  end
end