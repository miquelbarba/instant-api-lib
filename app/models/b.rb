class B < ActiveRecord::Base
  has_many :c
  belongs_to :a
end