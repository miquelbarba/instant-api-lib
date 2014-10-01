require 'jbuilder'

module InstantApi::Model
  module InstantApiRender
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :json_attributes, :associations

      def instant_api_render(json_attributes)
        @json_attributes = json_attributes
      end
    end

    def render_json
      Jbuilder.new do |object|
        self.class.json_attributes.each { |attribute| object.(self, attribute) }
      end.target!
    end
  end
end

