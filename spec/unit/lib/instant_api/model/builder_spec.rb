require 'spec_helper'
require 'instant_api/model/builder'

describe InstantApi::Model::Builder do
  subject { InstantApi::Model::Builder.new(params, model, true) }

  describe '#build' do
    let(:model)   { User }
    let(:params)  { { user: data }.with_indifferent_access }

    context 'successful' do
      context 'string parameter' do
        let(:data) { { email: 'a' } }
        it { validate_record(subject.build, :email, 'a') }
      end

      context 'integer parameter' do
        let(:data) { { age: 1 } }
        it { validate_record(subject.build, :age, 1) }
      end

      context 'date parameter' do
        let(:data)    { { born_at: '01/03/1974' } }
        let(:born_at) { Date.parse(data[:born_at]) }
        it { validate_record(subject.build, :born_at, born_at) }
      end

      context 'datetime parameter' do
        let(:data)          { { registered_at: '10:29 01/03/1974' } }
        let(:registered_at) { DateTime.parse(data[:registered_at]) }
        it { validate_record(subject.build, :registered_at, registered_at) }
      end

      context 'decimal parameter' do
        let(:data)  { { money: '10.99' } }
        let(:money) { BigDecimal.new('10.99') }
        it { validate_record(subject.build, :money, money) }
      end

      context 'boolean parameter' do
        context 'value true' do
          let(:data) { { terms_accepted: 1 } }
          it { validate_record(subject.build, :terms_accepted, true) }
        end

        context 'value false' do
          let(:data) { { terms_accepted: 0 } }
          it { validate_record(subject.build, :terms_accepted, false) }
        end
      end

      context 'build nested model' do
        let(:data) { { address: { street: 'a' } }.with_indifferent_access }

        it 'creates a record' do
          record = subject.build
          record.valid?.should be_true
          record.address.size.should eq(1)
        end
      end
    end

    context 'nested objects' do
      let(:model) { A }
      let(:params) do
        { a: { value: 'a', b: { value: 'b', c: { value: 'c' } } } }.with_indifferent_access
      end

      context 'successful' do
        it 'build the nested objects' do
          record = subject.build

          record.value.should eq('a')
          record.b.size.should eq(1)
          record.b.first.value.should eq('b')
          record.b.first.c.size.should eq(1)
          record.b.first.c.first.value.should eq('c')
        end
      end
    end

    context 'has_one' do
      let(:model) { A }
      let(:params) do
        { a: { value: 'a', c: { value: 'c' } } }.with_indifferent_access
      end

      it 'build the nested objects' do
        record = subject.build

        record.valid?.should be_true
        record.value.should eq('a')
        record.c.value.should eq('c')
        record.c.a.value.should eq('a')
      end
    end

    context 'has_many' do
      let(:model) { A }
      let(:params) do
        { a: { value: 'a', b: { value: 'b' } } }.with_indifferent_access
      end

      it 'build the nested objects' do
        record = subject.build

        record.valid?.should be_true
        record.value.should eq('a')
        record.b.map(&:value).to_a.should eq(['b'])
        record.b.first.a.should eq(record)
      end
    end

    context 'belongs_to' do
      let(:model) { B }
      let(:params) do
        { b: { value: 'b', a: { value: 'a' } } }.with_indifferent_access
      end

      it 'build the nested objects' do
        record = subject.build

        record.valid?.should be_true
        record.value.should eq('b')
        record.a.value.should eq('a')
        record.a.b.to_a.should eq([record])
      end
    end

    context 'has_and_belongs_to_many' do
      let(:model) { A }
      let(:params) do
        { a: { value: 'a', d: { value: 'd' } } }.with_indifferent_access
      end

      it 'build the nested objects' do
        record = subject.build

        record.valid?.should be_true
        record.value.should eq('a')
        record.d.map(&:value).to_a.should eq(['d'])
        record.d.first.a.to_a.should eq([record])
      end
    end

    context 'failed' do
      let(:data) { { email: 'a' } }
      after  { User.reset_callbacks(:validate) }

      context 'mandatory parameter' do
        let(:data) { Hash.new }
        before     { User.class_eval { validates_presence_of :email } }

        it { validate_error(subject.build, :email, "can't be blank") }
      end

      context 'length validations' do
        before { User.class_eval { validates :email, length: { minimum: 2 } } }

        it { validate_error(subject.build, :email, 'is too short (minimum is 2 characters)') }
      end

      context 'acceptance validation' do
        before { User.class_eval { validates_acceptance_of :terms, allow_nil: false } }

        it { validate_error(subject.build, :terms, 'must be accepted') }
      end

      context 'confirmation validation' do
        let(:data) { { email: 'a', email_confirmation: 'b' } }
        before { User.class_eval { validates :email, confirmation: true } }

        it { validate_error(subject.build, :email_confirmation, "doesn't match Email") }
      end

      context 'exclusion validation' do
        before { User.class_eval { validates :email, exclusion: { in: %w(a b) } } }

        it { validate_error(subject.build, :email, 'is reserved') }
      end

      context 'format validation' do
        before { User.class_eval { validates :email, format: { with: /[0-9]/ } } }

        it { validate_error(subject.build, :email, 'is invalid') }
      end

      context 'inclusion validation' do
        before { User.class_eval { validates :email, inclusion: { in: %w(b c) } } }

        it { validate_error(subject.build, :email, 'is not included in the list') }
      end

      context 'numericality validation' do
        before { User.class_eval { validates :email, numericality: true } }

        it { validate_error(subject.build, :email, 'is not a number') }
      end

      context 'absence validation' do
        before { User.class_eval { validates :email, absence: true } }

        it { validate_error(subject.build, :email, 'must be blank') }
      end

      context 'uniqueness validation' do
        before do
          User.create!(data)
          User.class_eval { validates :email, uniqueness: true }
        end

        it { validate_error(subject.build, :email, 'has already been taken', 1) }
      end
    end

    private
    def validate_error(record, field, msg, count = 0)
      record.valid?.should be_false
      record.errors.size.should eq(1)
      record.errors[field].should eq([msg])
      record.class.count.should eq(count)
    end

    def validate_record(record, field, value)
      record.valid?.should be_true
      record.send(field).should eq(value)
    end
  end
end