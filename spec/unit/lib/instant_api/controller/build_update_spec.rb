require 'spec_helper'

describe InstantApi::Controller::BuildUpdate do
  let(:controller)       { Object.new }
  let(:model_class_name) { 'OtherClass' }

  subject { InstantApi::Controller::BuildUpdate.new(controller, model_class_name) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:update).should be_true }

    describe '#update' do
      let(:resource)      { double('resource', valid?: true, invalid?: false) }
      let(:strong_params) { Object.new }

      before do
        resource.should_receive(:update_attributes!).with(strong_params)

        controller.should_receive(:resource).any_number_of_times.and_return(resource)
        controller.should_receive(:check_strong_parameters).and_return(strong_params)
        controller.should_receive(:render).with(json: resource).and_return(true)
      end

      it { controller.update.should be_true }
    end

    describe '#check_strong_parameters' do
      context 'with strong parameters' do
        let(:params)           { Object.new }
        let(:params_require)   { Object.new }
        let(:model_class_name) { 'AnotherClass' }
        class AnotherClass
          def self.strong_parameters
            'a'
          end
        end

        before do
          params.should_receive(:require).with(:another_class).and_return(params_require)
          params_require.should_receive(:permit).with('a').and_return(true)
          controller.should_receive(:params).and_return(params)
        end

        it { controller.send(:check_strong_parameters).should be_true }
      end

      context 'without strong parameters' do
        let(:params)         { Object.new }
        let(:params_require) { Object.new }
        let(:model_class_name) { 'OtherClass' }
        class OtherClass; end


        before do
          params.should_receive(:require).with(:other_class).and_return(params_require)
          params_require.should_receive(:permit!).and_return(true)
          controller.should_receive(:params).and_return(params)
        end

        it { controller.send(:check_strong_parameters).should be_true }
      end
    end
  end
end