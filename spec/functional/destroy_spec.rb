require 'spec_helper'

describe 'Destroy', type: :controller do
  let!(:user) { create(:user) }

  before do
    @controller = InstantApi::Controller::Builder.new('users', [:destroy]).build_class.new
  end

  it 'successful' do
    delete(:destroy, id: user.id)

    response.should be_successful
    User.where(id: user.id).should be_empty
  end

  it 'returns 404 when the resource does not exists' do
    delete(:destroy, id: user.id + 1)
    response.status.should eq(404)
  end
end