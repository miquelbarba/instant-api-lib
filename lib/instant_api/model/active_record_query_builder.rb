require 'instant_api/model/join_calculator'

module InstantApi::Model
  class ActiveRecordQueryBuilder
    attr_reader :model
    def initialize(model)
      @model = model
    end

    def query(params)
      if has_associations?(params)
        model.joins(build_joins(params)).
              where(build_conditions(params))
      else
        model.all
      end
    end

    def find_first(params)
      result = if has_associations?(params)
                 query(params).first
               else
                 model.find(params[:id])
               end
      raise ActiveRecord::RecordNotFound.new if !result
      result
    end

    private

    def has_associations?(params)
      params.resources.size > 1
    end

    def build_joins(params)
      InstantApi::Model::JoinCalculator.new(params.resources).calculate
    end

    def build_conditions(params)
      result = Hash.new
      result[:id] = params[:id] if params[:id]

      resource, *rest = *params.resources
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
  end
end