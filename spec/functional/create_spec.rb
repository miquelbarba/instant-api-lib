require 'spec_helper'

describe 'Create', type: :controller do
  let(:user_params) { attributes_for(:user) }

  before do
    @controller = InstantApi::Controller::Builder.new('users', [:create]).build_class.new
  end

  it 'successful' do
    post(:create, user: user_params)

    validate_user(JSON.parse(response.body).symbolize_keys, user_params)
  end

end