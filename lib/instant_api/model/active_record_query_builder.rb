
module InstantApi::Model
  class ActiveRecordQueryBuilder
    attr_reader :model, :request_path
    def initialize(model, request_path)
      @model, @request_path = model, request_path
    end

    def query(params)
      if has_associations?
        model.joins(build_joins(request_path)).
              where(build_conditions(request_path, params))
      else
        model.all
      end
    end

    def find_first(params)
      result = if has_associations?
                 query(params).first
               else
                 model.find(params[:id])
               end
      raise ActiveRecord::RecordNotFound.new if !result
      result
    end

    private

    def has_associations?
      resources_from_url(request_path).size > 1
    end

    def build_joins(url)
      *rest, _ = *resources_from_url(url)
      rest.reverse.map{|resource| resource.to_s.singularize.to_sym}.array_to_hash
    end

    def build_conditions(url, params)
      result = Hash.new
      result[:id] = params[:id] if params[:id]

      resource, *rest = *resources_from_url(url)
      klass = to_class(resource)
      rest.map do |association_name|
        if (assoc = association(klass, association_name))
          table = join_table(assoc)
          foreign_key = foreign_key(assoc)
          result[table] = { foreign_key => params[foreign_key] }
        end

        resource = association_name
        klass = to_class(resource)
      end

      result
    end

    def join_table(assoc)
      if assoc.has_and_belongs_to_many?
        assoc.join_table.to_sym
      else
        assoc.name.to_sym
      end
    end

    def foreign_key(assoc)
      assoc.foreign_key.to_sym
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
    end

    def association(klass, name)
      klass.reflect_on_association(name.to_s.pluralize.to_sym)
    end

    def resources_from_url(url)
      @resources_from_url ||= begin
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