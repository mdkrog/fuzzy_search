FactoryBot.define do  
  factory :item do
    item_name { Faker::Appliance.equipment }
  end
end