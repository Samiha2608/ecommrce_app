class ApplicationController < ActionController::Base
  include Pundit::Authorization
rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    root_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone_number, :address, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :phone_number, :address, :avatar ])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized for this action."
    redirect_to(request.referrer || root_path)
  end
end
