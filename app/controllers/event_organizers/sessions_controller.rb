class EventOrganizers::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Logged in successfully.', event_organizer: resource, token: request.env['warden-jwt_auth.token'] }, status: :ok
    else
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_event_organizer
      current_event_organizer.revoke_jwt!  # Invalidate token
      render json: { message: "Logged out successfully." }, status: :ok
    else
      render json: { error: "Event organizer not found or already logged out." }, status: :unauthorized
    end
  end
end
