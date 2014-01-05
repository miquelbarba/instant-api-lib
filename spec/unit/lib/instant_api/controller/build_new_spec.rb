require 'spec_helper'

describe InstantApi::Controller::BuildNew do
  let(:controller) { Object.new }

  subject { InstantApi::Controller::BuildNew.new(controller) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:new).should be_true }

    context 'call to new' do
      before { controller.should_receive(:head).with(:ok).and_return(true) }
      it { controller.new.should be_true }
    end
  end
end