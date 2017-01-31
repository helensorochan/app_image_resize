class User
  include Mongoid::Document

  field :login, type: String
  field :password, type: String

  has_many :sessions, class_name: 'Session', dependent: :destroy

  validates :login, :password, presence: true
end