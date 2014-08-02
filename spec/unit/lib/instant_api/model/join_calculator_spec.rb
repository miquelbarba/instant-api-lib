require 'spec_helper'
require 'instant_api/model/association_reflector'

describe InstantApi::Model::AssociationReflector do
  subject { InstantApi::Model::AssociationReflector.new(association_list) }

  context 'A' do
    let(:association_list) { [:users, :addresses, :countries] }
    it { subject.calculate_join.should eq([:address, address: :user]) }
  end

  context 'B' do
    let(:association_list) { [:users, :addresses] }
    it { subject.calculate_join.should eq([:user]) }
  end

  context 'C' do
    let(:association_list) { [:countries, :movies] }
    it { subject.calculate_join.should eq([:countries]) }
  end


  context 'D' do
    let(:association_list) { [:users, :movies] }
    it { subject.calculate_join.should eq([:user]) }
  end
end