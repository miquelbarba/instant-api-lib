require 'spec_helper'

describe InstantApi::Controller::BuildCreate do
  let(:controller)       { Object.new }
  let(:model_class_name) { 'Aclass' }

  subject { InstantApi::Controller::BuildCreate.new(controller, model_class_name) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:create).should be_true }

    context 'call to create' do
      let(:resource)   { double('resource', valid?: true, invalid?: false) }
      let(:params)     { Object.new }
      let(:parameters) { Object.new }
      let(:builder)    { double(:builder, build: resource) }
      class Aclass; end

      before do
        controller.should_receive(:params).and_return(params)
        controller.stub_chain(:request, :path).and_return('/path')

        InstantApi::Controller::Parameters.should_receive(:new).
                                           with(params, '/path').
                                           and_return(parameters)
        InstantApi::Model::Builder.should_receive(:new).
                                   with(parameters, Aclass, true).
                                   and_return(builder)

        controller.should_receive(:render).with({json: resource}).and_return(true)
      end

      it { controller.create.should be_true }
    end
  end
end