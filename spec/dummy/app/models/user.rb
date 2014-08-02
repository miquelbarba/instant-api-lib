class User < ActiveRecord::Base
  has_many :addresses
  has_one :movie

  def self.strong_parameters
    [:email, :age, :born_at, :registered_at, :terms_accepte, :money]
  end
end
