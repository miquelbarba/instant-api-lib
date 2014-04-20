FactoryGirl.define do
  factory :movie do
    name { Faker::Product.name }
  end
end