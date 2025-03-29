require 'rails_helper'

RSpec.describe "Event Organizer Authentication", type: :request do
  let(:event_organizer) { create(:event_organizer) }

  describe "Event Organizer Registration" do
    it "registers a new event organizer" do
      post "/event_organizers", params: {
        event_organizer: {
          name: "Organizer Test",
          email: "organizer@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq("Organizer registered successfully.")
    end
  end

  describe "Event Organizer Login" do
    it "logs in with correct credentials" do
      post "/event_organizers/sign_in", params: {
        event_organizer: {
          email: event_organizer.email,
          password: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("Logged in successfully.")
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "fails login with incorrect password" do
      post "/event_organizers/sign_in", params: {
        event_organizer: {
          email: event_organizer.email,
          password: "wrongpassword"
        }
      }, as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq("Invalid Email or password.")
    end
  end
end
