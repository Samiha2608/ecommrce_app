class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    root_path
  end

  private

  def configure_permitted_parameters
    # Fixed parameter names to match your User model
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone_number, :address, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :phone_number, :address, :avatar ])
  end
end
