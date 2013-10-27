class A < ActiveRecord::Base
  has_many :b
  has_one :c
  has_and_belongs_to_many :d
end