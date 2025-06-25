class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
    def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone_no, :address, :display_picture ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :phone_no, :address, :display_picture ])
    end
end
