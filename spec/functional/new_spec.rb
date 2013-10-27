require 'spec_helper'

describe 'New', type: :controller do
  let!(:user) { create(:user) }

  before do
    @controller = InstantApi::Controller::Builder.new('users', [:new]).build_class.new
  end

  it 'successful' do
    get(:new)
    response.should be_successful
  end
end