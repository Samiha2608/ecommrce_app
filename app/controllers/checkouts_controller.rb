class CheckoutsController < ApplicationController
  def create
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    cart = current_cart
    order = cart&.order

    if order.blank? || order.order_products.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    line_items = order.order_products.includes(:product).map do |op|
    product = op.product
    original_price = product.price
    coupon_code = session[:applied_coupon_code]
    applied_coupon = Coupon.find_by(code: coupon_code, active: true)

    discounted_price = if applied_coupon && product.coupon_id == applied_coupon.id
    (original_price * (1 - applied_coupon.discount.to_f / 100)).round(2)
    else
    original_price
    end


    {
      price_data: {
        currency: "usd",
        product_data: {
          name: product.product_name
        },
        unit_amount: (discounted_price * 100).to_i
      },
      quantity: op.quantity
    }
  end


  begin
    Rails.logger.info "Creating Stripe session with line_items: #{line_items.inspect}"
    Rails.logger.info "Using Stripe API key: #{Stripe.api_key}"

    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: line_items,
      mode: "payment",
      success_url: success_checkouts_url,
      cancel_url: cancel_checkouts_url
    )

    redirect_to session.url, allow_other_host: true

  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe error: #{e.class} - #{e.message}"
    redirect_to cart_path, alert: "Payment failed: #{e.message}"
  rescue => e
    Rails.logger.error "Unexpected error in checkout: #{e.class} - #{e.message}"
    redirect_to cart_path, alert: "Unexpected error: #{e.message}"
  end
  end


  def success
    cart = current_cart
    if cart&.order
      cart.order.update(status: true)
      cart.order.order_products.destroy_all
    end
    flash[:notice] = "Payment successful! Thank you for your purchase."
    redirect_to root_path
  end


  def cancel
    flash[:alert] = "Payment canceled. Please try again."
    redirect_to cart_path
  end
end
