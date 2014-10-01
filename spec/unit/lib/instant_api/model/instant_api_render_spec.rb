require 'spec_helper'
require 'instant_api/model/instant_api_render'

describe InstantApi::Model::InstantApiRender do
  before do
    User.class_eval do
      include InstantApi::Model::InstantApiRender
      instant_api_render [:email]
    end
  end

  describe '#render_json' do
    let(:params) { {email: 'aname'} }
    let(:object) { User.new(params) }

    it { object.render_json.as_json(params) }
  end
end