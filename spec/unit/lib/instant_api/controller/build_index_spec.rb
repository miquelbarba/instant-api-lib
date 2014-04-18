require 'spec_helper'

describe InstantApi::Controller::BuildIndex do
  let(:controller)       { Object.new }
  let(:model_class_name) { 'Aclass' }

  subject { InstantApi::Controller::BuildIndex.new(controller, model_class_name) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:index).should be_true }

    context 'call to index' do
      let(:paginated_collection) { Object.new }
      let(:params)  { Object.new }
      let(:request) { double(:request, path: '/a') }
      let(:response) do
        {
          collection: paginated_collection,
          pagination: {
            count: 7,
            page: 3,
            per_page: 5
          }
        }
      end

      before do
        model_collection = InstantApi::Model::Collection.any_instance
        model_collection.should_receive(:page).and_return(3)
        model_collection.should_receive(:per_page).and_return(5)
        model_collection.should_receive(:paginated_collection).and_return(paginated_collection)
        model_collection.should_receive(:count).and_return(7)

        controller.should_receive(:request).and_return(request)
        controller.should_receive(:params).and_return(params)
        controller.should_receive(:render).with(json: response).and_return(true)
      end

      it { controller.index.should be_true }
    end
  end
end