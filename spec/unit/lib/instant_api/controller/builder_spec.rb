require 'spec_helper'
require 'instant_api/controller/builder'

describe InstantApi::Controller::Builder do
  subject { InstantApi::Controller::Builder.new('users', [:index, :show]) }

  describe '#build_class' do
    it do
      controller = subject.build_class

      instance = controller.new
      instance.respond_to?(:show).should be_true
      instance.respond_to?(:index).should be_true
      instance.respond_to?(:edit).should be_false
    end

  end
end