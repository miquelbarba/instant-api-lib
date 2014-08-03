require 'instant_api'
require 'active_record/validations'

module InstantApi::Controller
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from Exception, with: :render_error
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActionController::RoutingError, with: :record_not_found
      rescue_from ActionController::UnknownController, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :rescue_record_invalid
    end

    def record_not_found(exception)
      render json: exception_to_json(exception), status: 404
    end

    def render_error(exception)
      render json: exception, status: 500
    end

    def rescue_record_invalid(exception)
      render json: exception_to_json(exception), status: 422
    end

    def exception_to_json(exception)
      hash =  case exception
              when ActiveRecord::RecordNotFound
                {field: :id, message: exception.message}
              when ActiveRecord::RecordInvalid
                exception.record.errors.messages.to_a
              end
      { errors: hash }
    end
  end
end