class Ticket < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy  # Delete associated bookings when ticket is deleted

  VALID_TICKET_TYPES = ["GENERAL", "VIP"].freeze

  validates :ticket_type, presence: true, inclusion: { in: VALID_TICKET_TYPES }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_available, numericality: { greater_than_or_equal_to: 0 }

  # Reduce ticket availability when a booking is made
  def reduce_availability!(quantity)
    update!(quantity_available: quantity_available - quantity)
  end
end
