# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone_number, :address, :display_picture ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :phone_number, :address, :display_picture ])
  end
end
