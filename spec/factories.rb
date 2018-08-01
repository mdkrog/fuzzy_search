FactoryBot.define do  
  factory :item do
    item_name { Faker::Appliance.equipment }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end