FactoryGirl.define do
  factory :user do
    email           { Faker::Internet.email }
    age             { 20 }
    born_at         { 20.years.ago }
    registered_at   { DateTime.now }
    terms_accepted  { true }
    money           { BigDecimal.new('4.2') }
  end
end