FactoryBot.define do
  factory :event_organizer do
    name { Faker::Company.name }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
