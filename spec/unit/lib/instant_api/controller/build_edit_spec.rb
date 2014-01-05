require 'spec_helper'

describe InstantApi::Controller::BuildEdit do
  let(:controller) { Object.new }

  subject { InstantApi::Controller::BuildEdit.new(controller) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:edit).should be_true }

    context 'call to edit' do
      let(:resource) { Object.new }

      before do
        controller.should_receive(:resource).and_return(resource)
        controller.should_receive(:render).with({json: resource}).and_return(true)
      end

      it { controller.edit.should be_true }
    end
  end
end