require 'spec_helper'

describe 'Update', type: :controller do
  let(:user) { create(:user) }

  before do
    @controller = InstantApi::Controller::Builder.new('users', [:update]).build_class.new
  end

  it 'successful' do
    put(:update, id: user.id, user: {email: 'hello@at.com'})

    user[:email] = 'hello@at.com'
    validate_user(JSON.parse(response.body).symbolize_keys, user)
    response.should be_successful
  end

  it 'returns 404 when the resource does not exists' do
    put(:update, id: user.id + 1, user: {email: 'hello@at.com'})
    response.status.should eq(404)
  end

  context 'returns error' do
    after { User.reset_callbacks(:validate) }

    before { User.class_eval { validates :email, length: { minimum: 2 } } }

    it 'error in email' do
      put(:update, id: user.id, user: {email: 'a'})
      validate_errors(response.body,
                      [['email', ['is too short (minimum is 2 characters)']]])
    end

    context 'returns several errors' do
      before do
        User.class_eval { validates :age, numericality: { greater_than: 10 } }
      end

      it 'error in email and age' do
        put(:update, id: user.id, user: {email: 'a', age: 3})
        validate_errors(response.body,
                        [['email', ['is too short (minimum is 2 characters)']],
                         ['age', ['must be greater than 10']]])
      end
    end
  end
end