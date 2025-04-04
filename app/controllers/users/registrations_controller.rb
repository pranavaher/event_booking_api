class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Signed up successfully.', user: resource, token: request.env['warden-jwt_auth.token'] }, status: :created
    else
      render json: { error: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
