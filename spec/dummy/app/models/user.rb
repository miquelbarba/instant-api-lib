class User < ActiveRecord::Base
  has_many :addresses

  def self.strong_parameters
    [:email, :age, :born_at, :registered_at, :terms_accepte, :money]
  end
end
