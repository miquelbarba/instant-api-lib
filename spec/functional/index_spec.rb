require 'spec_helper'

describe 'Index', type: :controller do
  before do
    @controller = InstantApi::Controller::Builder.new('users', [:index]).build_class.new
  end

  context 'returns empty data' do
    it 'successful' do
      get(:index)

      json = JSON.parse(response.body).symbolize_keys
      validate_pagination(json[:pagination], 0, 1, 10)
      json[:collection].should be_empty
    end
  end

  context 'pagination' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    context 'all in same page' do
      let(:expected_collection) { [user1, user2] }

      it 'return first user' do
        get(:index)

        json = JSON.parse(response.body).symbolize_keys
        validate_pagination(json[:pagination], 2, 1, 10)
        validate_user_collection(json[:collection], expected_collection)
      end
    end

    context 'first page' do
      let(:expected_collection) { [user1] }

      it 'return first user' do
        get(:index, page: 1, per_page: 1)

        json = JSON.parse(response.body).symbolize_keys
        validate_pagination(json[:pagination], 2, 1, 1)
        validate_user_collection(json[:collection], expected_collection)
      end
    end

    context 'second page' do
      let(:expected_collection) { [user2] }

      it 'record second user' do
        get(:index, page: 2, per_page: 1)

        json = JSON.parse(response.body).symbolize_keys
        validate_pagination(json[:pagination], 2, 2, 1)
        validate_user_collection(json[:collection], expected_collection)
      end
    end

    context 'a page that does not exists' do
      let(:expected_collection) { [] }

      it 'returns nothing' do
        get(:index, page: 2)

        json = JSON.parse(response.body).symbolize_keys
        validate_pagination(json[:pagination], 2, 2, 10)
        validate_user_collection(json[:collection], expected_collection)
      end
    end

    context 'invalid page number' do
      let(:expected_collection) { [user1, user2] }

      it 'returns first page' do
        get(:index, page: 'a')

        json = JSON.parse(response.body).symbolize_keys
        validate_pagination(json[:pagination], 2, 1, 10)
        validate_user_collection(json[:collection], expected_collection)
      end
    end
  end
end