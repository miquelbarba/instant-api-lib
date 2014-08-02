
#params.resources: [:users, :addresses]
#request path: /users/1/addresses
# query: Address.joins(:users)

# has_many
# has_one
# belongs_to
# has_and_belongs_to_many
# Company
# has_many :employees
#  company.employees PLURAL
# Employee
# belongs_to :company
#  employee.company SINGULAR
# has_one :office
#  company.office
# has_and_belongs_to_many
#  company.offices


module InstantApi::Model
  class AssociationReflector

    def initialize(association_list)
      @association_list = association_list
    end

    def calculate_join
      *associations, resource = *@association_list
      klass = to_class(resource)
      first, *rest = *associations.reverse

      result = []
      if (assoc = association(klass, first))
        result << assoc.name.to_sym
        klass = to_class(first)
      end

      if rest
        rest.each do |association_name|
          if (assoc = association(klass, association_name))
            result << {klass.name.downcase.to_sym => assoc.name.to_sym}
            klass = to_class(association_name)
          end
        end
      end

      result
    end

    def calculate_conditions(params)
      result = Hash.new
      result[:id] = params[:id] if params[:id]

      resource, *rest = *params.resources
      klass = to_class(resource)
      rest.map do |association_name|
        if (assoc = association(klass, association_name))
          table = join_table(assoc)
          foreign_key = foreign_key(assoc)
          result[table] = { foreign_key => params[foreign_key] }
        end

        resource = association_name
        klass = to_class(resource)
      end

      result
    end

    def join_table(assoc)
      if assoc.has_and_belongs_to_many?
        assoc.join_table.to_sym
      else
        assoc.name.to_sym
      end
    end

    def foreign_key(assoc)
      assoc.foreign_key.to_sym
    end

    def association(klass, name)
      klass.reflect_on_association(name.to_s.singularize.to_sym) ||
          klass.reflect_on_association(name.to_s.pluralize.to_sym)
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
    end
  end
end