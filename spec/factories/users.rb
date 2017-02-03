FactoryGirl.define do
  factory :user do
    login { Faker::Name.first_name }
    password{ Faker::Internet.password }
  end
end
