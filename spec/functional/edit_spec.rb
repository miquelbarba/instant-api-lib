require 'spec_helper'

describe 'Edit', type: :controller do
  let!(:user) { create(:user) }

  before do
    @controller = InstantApi::Controller::Builder.new('users', [:edit]).build_class.new
  end

  it 'successful' do
    get(:edit, id: user.id)
    response.should be_successful
  end

  it 'returns 404 when the resource does not exists' do
    get(:edit, id: user.id + 1)
    response.status.should eq(404)
  end
end