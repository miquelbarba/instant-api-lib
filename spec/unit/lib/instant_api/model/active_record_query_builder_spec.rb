require 'spec_helper'
require 'instant_api/controller/parameters'
require 'instant_api/model/builder'
require 'instant_api/model/active_record_query_builder'

describe InstantApi::Model::ActiveRecordQueryBuilder do
  subject      { InstantApi::Model::ActiveRecordQueryBuilder.new(model) }
  let(:params) { InstantApi::Controller::Parameters.new(rails_params, request_path) }

  let(:user)    { create(:user) }
  let(:address) { create(:address, user_id: user.id) }
  let(:country) { create(:country, address_id: address.id) }

  let(:another_user)    { create(:user) }
  let(:another_address) { create(:address, user_id: another_user.id) }
  let(:another_country) { create(:country, address_id: another_address.id) }

  describe '#query' do
    context 'returns all first level model' do
      let(:model)        { User }
      let(:rails_params) { Hash.new }
      let(:request_path) { '/users' }
      it { subject.query(params).should eq([user]) }
    end

    context 'return all second level model' do
      let(:model)        { Address }
      let(:rails_params) { { user_id: user.id } }
      let(:request_path) { "/users/#{user.id}/addresses" }

      it { subject.query(params).should eq([address]) }
    end

    context 'additional parameters' do
      let(:model)        { Address }
      let(:rails_params) { { user_id: user.id, city: 'Barcelona' } }
      let(:request_path) { "/users/#{user.id}/addresses" }
      let(:address2) { create(:address, user_id: user.id, city: 'Barcelona') }
      let(:address3) { create(:address, user_id: user.id, city: 'Madrid') }

      it { subject.query(params).should eq([address2]) }
    end

    context 'query second level model with an invalid id, returns nothing' do
      let(:model)        { Address }
      let(:rails_params) { { user_id: user.id } }
      let(:request_path) { "/users/#{user.id}/addresses/#{another_address.id}" }

      it { subject.query(params).should be_empty }
    end

    context 'return all third level model' do
      let(:model)        { Country }
      let(:rails_params) { { user_id: user.id, address_id: address.id } }
      let(:request_path) { "/users/#{user.id}/addresses/#{address.id}/countries" }

      it { subject.query(params).should eq([country]) }
    end

    context 'query third level model with an invalid id, returns nothing' do
      let(:model)        { Country }
      let(:rails_params) { { user_id: user.id, address_id: another_address.id } }
      let(:request_path) { "/users/#{user.id}/addresses/#{another_address.id}/countries" }

      it { subject.query(params).should be_empty }
    end

    context 'return all third level model with additional params' do
      let(:model)        { Country }
      let(:rails_params) { { user_id: user.id, address_id: address.id } }
      let(:request_path) { "/users/#{user.id}/addresses/#{address.id}/countries" }

      context 'return data' do
        before { rails_params[:name] = country.name }
        it { subject.query(params).should eq([country]) }
      end

      # TODO
      #context 'return nothins' do
      #  before { params[:name] = country.name + 'nothing' }
      #  it { subject.query(params).should be_empty }
      #end
    end

    context 'has_and_belongs_to_many' do
      let(:movie) { create(:movie, countries: [country]) }
      before { country.movies = [movie] }

      let(:model) { Country }
      let(:rails_params) { { movie_id: movie.id } }
      let(:request_path) { "/movies/#{movie.id}/countries" }

      it { subject.query(params).should eq([country]) }
    end
  end

  describe '#find_first' do
    context 'returns first level model' do
      let(:model)        { User }
      let(:rails_params) { { id: user.id } }
      let(:request_path) { "/users/#{user.id}" }
      it { subject.find_first(params).should eq(user) }
    end

    context 'raises exception if no item exists' do
      let(:model)        { User }
      let(:rails_params) { { id: user.id + another_user.id } }
      let(:request_path) { "/users/#{user.id}" }
      it { expect { subject.find_first(params) }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'raises exception if no id is passed' do
      let(:model)        { User }
      let(:rails_params) { Hash.new }
      let(:request_path) { "/users/#{user.id}" }
      it { expect { subject.find_first(params) }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'returns second level model' do
      let(:model)        { Address }
      let(:rails_params) { { user_id: user.id, id: address.id } }
      let(:request_path) { "/users/#{user.id}/addresses/#{address.id}" }
      it { subject.find_first(params).should eq(address) }
    end

    context 'second level model with invalid id, raises exception' do
      let(:model)        { Address }
      let(:rails_params) { { user_id: user.id, id: another_address.id } }
      let(:request_path) { "/users/#{user.id}/addresses/#{another_address.id}" }
      it { expect { subject.find_first(params) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end