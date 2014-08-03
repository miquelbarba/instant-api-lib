module InstantApi::Controller
  class Parameters
    INTERNAL_PARAMS = %w(controller action format _method only_path)
    RAILS_METHODS = %i(new edit)

    attr_reader :params, :request_path

    # params is the rails params  {"actionF"=>"index", "controller"=>"countries", "id" => 3}
    # request: /users/2/addresses/3/edit
    def initialize(params, request_path)
      @params = params.except(*INTERNAL_PARAMS)
      @request_path = request_path
    end

    def [](key)
      params[key]
    end

    def select(&block)
      params.select(&block)
    end

    # '/users/2/addresses/3/edit' -> [:users, :addresses]
    def resources
      @resources ||= begin
        resources = request_path.strip.
                                 split('/').
                                 compact.
                                 map(&:strip).
                                 each_with_index.
                                 select { |_, index| index % 2 == 1 }.
                                 map { |a, _| a.to_sym }

        *rest, tail = *resources
        if RAILS_METHODS.index(tail)
          rest
        else
          resources
        end
      end
    end
  end
end