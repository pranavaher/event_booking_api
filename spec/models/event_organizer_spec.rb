require 'rails_helper'

RSpec.describe EventOrganizer, type: :model do
  describe "Validations" do
    it "is invalid without a name" do
      event_organizer = EventOrganizer.new(email: "eo@example.com", password: "password123")
      expect(event_organizer).not_to be_valid
      expect(event_organizer.errors[:name]).to include("can't be blank")
    end
  end
end
