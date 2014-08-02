require 'instant_api/model/association_reflector'

module InstantApi::Model
  class ActiveRecordQueryBuilder
    attr_reader :model
    def initialize(model)
      @model = model
    end

    def query(params)
      if has_associations?(params)
        reflector = InstantApi::Model::AssociationReflector.new(params.resources)
        model.joins(reflector.calculate_join).
              where(reflector.calculate_conditions(params))
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
  end
end