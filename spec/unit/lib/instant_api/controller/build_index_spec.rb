require 'spec_helper'

describe InstantApi::Controller::BuildIndex do
  let(:controller)       { Object.new }
  let(:model_class_name) { 'Aclass' }

  subject { InstantApi::Controller::BuildIndex.new(controller, model_class_name) }

  describe '#build' do
    before { subject.build }

    it { controller.respond_to?(:index).should be_true }

    context 'call to page' do
      before { controller.should_receive(:params).and_return(params) }

      context 'non-zero positive page' do
        let(:params) { {page: 3} }
        it { controller.send(:page).should eq(3) }
      end

      context 'zero page' do
        let(:params) { {page: 0} }
        it { controller.send(:page).should eq(1) }
      end

      context 'without parameter' do
        let(:params) { {} }
        it { controller.send(:page).should eq(1) }
      end
    end

    context 'call to per_page' do
      before { controller.should_receive(:params).and_return(params) }

      context 'non-zero positive per_page' do
        let(:params) { {per_page: 3} }
        it { controller.send(:per_page).should eq(3) }
      end

      context 'zero per_page' do
        let(:params) { {per_page: 0} }
        it { controller.send(:per_page).should eq(10) }
      end

      context 'max per_page' do
        let(:params) { {per_page: 11} }
        it { controller.send(:per_page).should eq(10) }
      end

      context 'without parameter' do
        let(:params) { {} }
        it { controller.send(:per_page).should eq(10) }
      end
    end

    context 'call to collection' do
      let(:collection) { Object.new }
      class Aclass; end

      before { Aclass.should_receive(:all).and_return(collection) }

      it { controller.send(:collection).should eq(collection) }
    end

    context 'call to paginated_collection' do
      let(:collection)      { Object.new }
      let(:collection_page) { Object.new }
      let(:result)          { Object.new }

      before do
        controller.should_receive(:page).and_return(2)
        controller.should_receive(:per_page).and_return(4)
        controller.should_receive(:collection).twice.and_return(collection)
        collection.should_receive(:page).with(2).and_return(collection_page)
        collection_page.should_receive(:per).with(4).and_return(result)
      end

      it { controller.send(:paginated_collection).should eq(result) }
    end

    context 'call to index' do
      let(:paginated_collection) { Object.new }
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
      class Aclass; end

      before do
        Aclass.should_receive(:count).and_return(7)
        controller.should_receive(:page).and_return(3)
        controller.should_receive(:per_page).and_return(5)
        controller.should_receive(:paginated_collection).and_return(paginated_collection)
        controller.should_receive(:render).with(json: response).and_return(true)
      end

      it { controller.index.should be_true }
    end
  end
end