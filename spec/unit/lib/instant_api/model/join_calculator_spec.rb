require 'spec_helper'
require 'instant_api/model/join_calculator'

describe InstantApi::Model::JoinCalculator do
  subject { InstantApi::Model::JoinCalculator.new(association_list) }

  context 'A' do
    let(:association_list) { [:users, :addresses, :countries] }
    it { subject.calculate.should eq([:address, address: :user]) }
  end

  context 'B' do
    let(:association_list) { [:users, :addresses] }
    it { subject.calculate.should eq([:user]) }
  end

  context 'C' do
    let(:association_list) { [:countries, :movies] }
    it { subject.calculate.should eq([:countries]) }
  end


  context 'D' do
    let(:association_list) { [:users, :movies] }
    it { subject.calculate.should eq([:user]) }
  end
end