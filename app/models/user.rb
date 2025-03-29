class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtRevocationStrategy

  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: { in: %w[user admin] }
end
