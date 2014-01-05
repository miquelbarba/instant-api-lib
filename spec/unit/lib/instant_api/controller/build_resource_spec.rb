require 'spec_helper'

describe InstantApi::Controller::BuildResource do
  let(:controller)       { Object.new }
  let(:model_class_name) { 'Aclass' }

  subject { InstantApi::Controller::BuildResource.new(controller, model_class_name) }

  describe '#build' do
    before { subject.build }

    context 'call to resource' do
      let(:resource) { Object.new }
      let(:params)   { {id: 3} }
      class Aclass; end

      before do
        controller.should_receive(:params).and_return(params)
        Aclass.should_receive(:find).with(3).and_return(resource)
      end

      it { controller.send(:resource).should eq(resource) }
    end
  end
end