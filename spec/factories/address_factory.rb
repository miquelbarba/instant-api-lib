FactoryGirl.define do
  factory :address do
    street      { Faker::Address.street_name }
    number      { Faker::Address.building_number }
    postal_code { Faker::AddressUS.zip_code }
    city        { Faker::Address.city }
  end
end