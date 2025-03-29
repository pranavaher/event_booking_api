require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event_organizer) { EventOrganizer.create!(name: "Test Organizer", email: "test@example.com", password: "password") }

  subject {
    described_class.new(
      name: "Music Concert",
      description: "Live music event",
      start_time: Time.current + 1.day,
      end_time: Time.current + 2.days,
      venue: "Downtown Arena",
      event_organizer: event_organizer
    )
  }

  context "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a start_time" do
      subject.start_time = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without an end_time" do
      subject.end_time = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a venue" do
      subject.venue = nil
      expect(subject).not_to be_valid
    end

    it "is not valid if start_time is after end_time" do
      subject.start_time = Time.current + 3.days
      subject.end_time = Time.current + 2.days
      expect(subject).not_to be_valid
    end
  end
end
