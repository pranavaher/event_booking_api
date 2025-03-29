require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is invalid without a first_name" do
      user = User.new(last_name: "Doe", email: "test@example.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it "is invalid without a last_name" do
      user = User.new(first_name: "John", email: "test@example.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end
  end
end
