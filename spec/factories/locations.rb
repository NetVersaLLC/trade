# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :location do
    name 'United States'
    short_name 'USA'
    location_type 'country'
    parent_location_id "0"
  end

end
