class EventOrganizers::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:event_organizer).permit(:name, :email, :password, :password_confirmation)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Organizer registered successfully.', event_organizer: resource, token: request.env['warden-jwt_auth.token'] }, status: :created
    else
      render json: { error: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
