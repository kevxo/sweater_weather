class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: { case_sensitive: false}, presence: true
  validates :api_key, uniqueness: true
  validates :password, confirmation: true
  before_create do |user|
    user.api_key = User.generate_api_key
  end

  def self.generate_api_key
    loop do
      token = SecureRandom.uuid
      break token unless User.exists?(api_key: token)
    end
  end

end
