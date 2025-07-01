class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      transfer_guest_cart_to(user)
    end
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
