class EventOrganizer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtRevocationStrategy

  has_many :events, dependent: :destroy

  validates :name, presence: true
end
