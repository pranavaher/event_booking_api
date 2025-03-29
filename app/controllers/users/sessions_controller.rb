class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Logged in successfully.', user: resource, token: request.env['warden-jwt_auth.token'] }, status: :ok
    else
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_user
      current_user.revoke_jwt!  # Invalidate token by updating jti
      render json: { message: "Logged out successfully." }, status: :ok
    else
      render json: { error: "User not found or already logged out." }, status: :unauthorized
    end
  end
end
