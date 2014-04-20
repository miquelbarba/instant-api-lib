class Address < ActiveRecord::Base
  belongs_to :user
  has_many :countries
end
