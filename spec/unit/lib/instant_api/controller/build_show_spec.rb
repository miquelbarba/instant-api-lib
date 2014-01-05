require 'spec_helper'

describe InstantApi::Controller::BuildShow do
  let(:controller) { Object.new }

  subject { InstantApi::Controller::BuildShow.new(controller) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:show).should be_true }

    context 'call to show' do
      let(:resource) { Object.new }

      before do
        controller.should_receive(:resource).and_return(resource)
        controller.should_receive(:render).with({json: resource}).and_return(true)
      end

      it { controller.show.should be_true }
    end
  end
end