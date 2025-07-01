class ApplicationController < ActionController::Base
  include Pundit::Authorization
rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper ProductsHelper

  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_render_cart
  before_action :initialize_cart

  def after_sign_in_path_for(resource)
    root_path
  end

  def set_render_cart
    @render_cart = true
  end

  def initialize_cart
    if user_signed_in?
      @cart = current_user.carts.last || current_user.carts.create
      session[:cart_id] = @cart.id
    else
      @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] = @cart.id
    end
  end


  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone_number, :address, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :phone_number, :address, :avatar ])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized for this action."
    redirect_to(request.referer || root_path)
  end
end
