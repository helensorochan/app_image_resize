FactoryGirl.define do
  factory :picture do
    user { create :user }
    content_type { 'images/png' }
    height { 100 }
    width { 100 }
  end
end
