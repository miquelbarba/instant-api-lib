module InstantApi::Model
  class Resource
    attr_reader :params, :query_builder

    def initialize(klass, request_path, params)
      @params = params
      @query_builder = InstantApi::Model::ActiveRecordQueryBuilder.new(klass, request_path)
    end

    def find
      if query_builder.parent?
        query_builder.find(params)
      else
        query_builder.find_by_id(params[:id])
      end
    end
  end
end