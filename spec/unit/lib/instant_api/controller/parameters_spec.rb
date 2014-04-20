require 'spec_helper'
require 'instant_api/controller/parameters'

describe InstantApi::Controller::Parameters do
  subject { InstantApi::Controller::Parameters.new(params, request_path) }

  describe '#[]' do
    let(:request_path) { '/users' }

    context 'a string key' do
      let(:params) { { 'id' => 3 } }
      it { subject['id'].should eq(3) }
    end

    context 'a symbol key' do
      let(:params) { { id: 3 } }
      it { subject[:id].should eq(3) }
    end

    context 'remove internal rails params' do
      %w(controller action format _method only_path).each do |param|
        let(:params) { { param => 'hi' } }
        it { subject[param].should be_nil }
      end
    end
  end

  describe '#resources' do
    let(:params) { Hash.new }

    context 'return the resources' do
      let(:request_path) { '/users/2/addresses' }
      it { subject.resources.should eq([:users, :addresses]) }
    end

    context 'ignore trailing /' do
      let(:request_path) { '/users/2/addresses/' }
      it { subject.resources.should eq([:users, :addresses]) }
    end

    context 'ignore trailing /' do
      let(:request_path) { '/users/2/addresses/2/ ' }
      it { subject.resources.should eq([:users, :addresses]) }
    end

    context 'remove the rails methods' do
      %w(new edit).each do |method|
        let(:request_path) { "/users/2/addresses/#{method}" }
        it { subject.resources.should eq([:users, :addresses]) }
      end
    end
  end
end