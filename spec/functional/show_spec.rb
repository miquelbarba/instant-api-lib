require 'spec_helper'

describe 'Show', type: :controller do
  let(:user) { create(:user) }

  before do
    @controller = InstantApi::Controller::Builder.new('users', [:show]).build_class.new
  end

  it 'successful' do
    get(:show, id: user.id)

    validate_user(JSON.parse(response.body).symbolize_keys, user)
  end

  it 'returns 404 when the resource does not exists' do
    get(:show, id: user.id + 1)
    response.status.should eq(404)
  end
end