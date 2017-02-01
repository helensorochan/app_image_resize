FactoryGirl.define do
  factory :session do
    user { create :user }
    app_version { ALLOWED_VERSIONS.last }
    value { Session.generate_value }
    device { '12345' }
  end
end