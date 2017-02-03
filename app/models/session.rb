class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: String
  field :app_version, type: String
  field :device, type: String

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  validates :value, :app_version, :device, :user, presence: true

  def self.generate_value
    SecureRandom.hex(32)
  end
end
