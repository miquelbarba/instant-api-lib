require 'spec_helper'

describe InstantApi::Controller::BuildDestroy do
  let(:controller) { Object.new }

  subject { InstantApi::Controller::BuildDestroy.new(controller) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:destroy).should be_true }

    context 'call to destroy' do
      let(:resource) { double(:resource, destroy!: true) }

      before do
        controller.should_receive(:resource).and_return(resource)
        controller.should_receive(:render).with({status: 200, nothing: true}).
                                           and_return(true)
      end

      it { controller.destroy.should be_true }
    end
  end
end