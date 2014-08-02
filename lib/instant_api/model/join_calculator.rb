
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
  class JoinCalculator

    def initialize(association_list)
      @association_list = association_list
    end

    def calculate
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


    def association(klass, name)
      klass.reflect_on_association(name.to_s.singularize.to_sym) ||
          klass.reflect_on_association(name.to_s.pluralize.to_sym)
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
    end
  end
end