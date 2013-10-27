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
      @params_for_klass ||= params[klass.name.underscore]
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