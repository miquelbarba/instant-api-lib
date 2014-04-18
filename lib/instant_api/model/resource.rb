module InstantApi::Model
  class Resource
    attr_reader :params, :query_builder

    def initialize(klass, request_path, params)
      @params = params
      @query_builder = InstantApi::Model::ActiveRecordQueryBuilder.new(klass, request_path)
    end

    def find
      query_builder.find_first(params)
    end
  end
end