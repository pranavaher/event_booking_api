require 'rails_helper'

RSpec.describe "Events API", type: :request do
  let(:event_organizer) { EventOrganizer.create!(name: "Test Organizer", email: "organizer@example.com", password: "password") }
  let(:token) do
    post "/event_organizers/sign_in", params: { event_organizer: { email: event_organizer.email, password: "password" } }
    JSON.parse(response.body)["token"]
  end

  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }

  let!(:event) { Event.create!(name: "Concert", start_time: Time.current + 1.day, end_time: Time.current + 2.days, venue: "Stadium", event_organizer: event_organizer) }

  describe "GET /events" do
    it "returns all events" do
      get "/events"
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to have_key("event")
    end
  end

  describe "GET /events/:id" do
    it "returns the event details" do
      get "/events/#{event.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Concert")
    end

    it "returns 404 if event not found" do
      get "/events/99999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /events" do
    let(:valid_event_params) do
      {
        event: {
          name: "New Event",
          start_time: Time.current + 1.day,
          end_time: Time.current + 2.days,
          venue: "New Venue"
        }
      }.to_json
    end

    it "creates a new event" do
      post "/events", params: valid_event_params, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq("Event created successfully.")
    end
  end

  describe "PATCH /events/:id" do
    it "updates an event" do
      patch "/events/#{event.id}", params: { event: { name: "Updated Event" } }.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["event"]["name"]).to eq("Updated Event")
    end
  end

  describe "DELETE /events/:id" do
    it "deletes an event" do
      delete "/events/#{event.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Event deleted successfully.")
    end
  end
end
