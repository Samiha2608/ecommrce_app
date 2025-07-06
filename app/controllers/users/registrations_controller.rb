# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
    super do |user|
      transfer_guest_cart_to(user)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone_number, :address, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :phone_number, :address, :avatar ])
  end

  private

  def transfer_guest_cart_to(user)
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      if cart && cart.user.nil?
        cart.update(user: user)
      end
    end
  end
end
