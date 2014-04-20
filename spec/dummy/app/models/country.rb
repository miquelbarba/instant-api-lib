class Country < ActiveRecord::Base
  belongs_to :address
  has_and_belongs_to_many :movies
end
