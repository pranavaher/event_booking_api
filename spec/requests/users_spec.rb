require 'rails_helper'

RSpec.describe "User Authentication", type: :request do
  let(:user) { create(:user) }

  describe "User Registration" do
    it "registers a new user" do
      post "/users", params: {
        user: {
          first_name: "Test",
          last_name: "User",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq("Signed up successfully.")
    end
  end

  describe "User Login" do
    it "logs in with correct credentials" do
      post "/users/sign_in", params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("Logged in successfully.")
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "fails login with incorrect password" do
      post "/users/sign_in", params: {
        user: {
          email: user.email,
          password: "wrongpassword"
        }
      }, as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq("Invalid Email or password.")
    end
  end
end
