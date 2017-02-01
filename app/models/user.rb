class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :login, type: String
  field :password_digest
  has_secure_password

  has_many :sessions, class_name: 'Session', dependent: :destroy

  validates :login, presence: true, uniqueness: true
end