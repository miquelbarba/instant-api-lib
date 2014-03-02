# InstanceBuilder
module InstantApi::Model
  class Builder
    attr_reader :params, :klass, :root

    def initialize(params, klass, root = false)
      @params = params
      @klass = klass
      @root = root
    end

    def build
      record = nil
      klass.transaction do
        record = klass.create(params_primitives).tap do |object|
          create_nested_records(object)
        end

        raise ActiveRecord::Rollback if rollback?(record)
      end

      record
    end

    private

    def rollback?(record)
      root && record.invalid?
    end

    def params_primitives
      params_for_klass.select { |_, v| !v.is_a?(Enumerable) }
    end

    def params_enumerables
      params_for_klass.select { |_, v| v.is_a?(Enumerable) }
    end

    def params_for_klass
      @params_for_klass ||= begin
        name = klass.name.underscore
        klass_params = params[name] ? params[name] : params
        klass_params.select { |k, _| klass_attributes.index(k) }
      end
    end

    def klass_attributes
      @klass_attributes ||= plain_attributes + association_attributes
    end

    def plain_attributes_confirmation
      validator_class = ActiveModel::Validations::ConfirmationValidator
      klass.column_names.select do |column|
        validators = klass.validators_on(column)
        validators.select { |validator| validator.is_a?(validator_class) }.any?
      end.map { |column| "#{column}_confirmation" }
    end

    def plain_attributes
      klass.column_names + plain_attributes_confirmation
    end

    ASSOCIATION_TYPES = [:belongs_to, :has_many, :has_one, :has_and_belongs_to_many]
    def association_attributes
      ASSOCIATION_TYPES.map do |type|
        klass.reflect_on_all_associations(type).map(&:name).map(&:to_s)
      end.flatten
    end

    def create_nested_records(record)
      params_enumerables.each do |nested_name, nested_params|
        if (association = klass.reflections[nested_name.to_sym])
          nested_object = create_nested_record(nested_name, nested_params)
          add_association(record, association.macro, nested_name, nested_object)
        end
      end
    end

    def add_association(record, association_type, nested_name, nested_object)
      case association_type
      when :has_many, :has_and_belongs_to_many
        record.send(nested_name) << nested_object
      when :has_one, :belongs_to
        record.send("#{nested_name}=", nested_object)
        record.save
      end
    end

    def create_nested_record(nested_name, nested_params)
      nested_class = nested_name.classify.constantize
      new_params = {nested_name => nested_params}.with_indifferent_access
      InstantApi::Model::Builder.new(new_params, nested_class).build
    end
  end
end