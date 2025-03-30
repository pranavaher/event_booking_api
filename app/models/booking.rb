class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :quantity, numericality: { greater_than: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_create :validate_ticket_availability
  after_create :update_ticket_availability

  private

  def validate_ticket_availability
    if ticket.quantity_available < quantity
      errors.add(:quantity, "exceeds available tickets")
      throw :abort
    end
  end

  def update_ticket_availability
    ticket.reduce_availability!(quantity)
  end
end
