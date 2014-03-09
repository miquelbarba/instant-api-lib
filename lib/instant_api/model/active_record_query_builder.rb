
module InstantApi::Model
  class ActiveRecordQueryBuilder
    attr_reader :klass, :request_path
    def initialize(klass, request_path)
      @klass, @request_path, @params = klass, request_path
    end

    def collection(params)
      klass.joins(build_joins(request_path)).
            where(build_params(request_path, params))
    end

    def find(params)
      result = klass.joins(build_joins(request_path)).
                     where(build_params(request_path, params, params[:id])).first
      raise ActiveRecord::RecordNotFound.new if !result
      result
    end

    def find_by_id(id)
      klass.find(id)
    end


    def all
      klass.all
    end

    def parent?
      resources(request_path).size > 1
    end

    private

    def build_joins(url)
      *rest, _ = *resources(url)
      rest
    end

    def build_params(url, params, id = nil)
      result = Hash.new
      result[:id] = id if id

      resource, *rest = *resources(url)
      klass = to_class(resource)
      rest.map do |association_name|
        if (assoc = association(klass, association_name))
          table = assoc.join_table
          result[table] = { assoc.foreign_key => params[assoc.foreign_key] }
        end

        resource = association_name
        klass = to_class(resource)
      end

      result
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
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
