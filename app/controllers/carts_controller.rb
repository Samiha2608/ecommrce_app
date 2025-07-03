class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :add_to_cart, :show, :remove_item, :update_quantity ]
  before_action :set_product, only: [ :add_to_cart ]

  def show
    cart = current_cart
    @order = cart&.order
    @cart_items = @order&.order_products&.includes(:product) || []

    if session[:applied_coupon_id]
      coupon = Coupon.find_by(id: session[:applied_coupon_id])
      if coupon
        matching_items = @cart_items.select { |item| item.product.coupon_id == coupon.id }
        if matching_items.any?
          calculate_totals_with_coupon(cart, coupon)
        else
          session.delete(:applied_coupon_id)
        end
      end
    end
  end




  def apply_coupon
    coupon_code = params[:coupon_code]

    unless coupon_code =~ /\A\d{6}\z/
      flash[:coupon_error] = "Coupon code must be a 6-digit number."
      redirect_to cart_path and return
    end

    @cart = user_signed_in? ? current_user.carts.order(created_at: :desc).first : Cart.find_by(id: session[:cart_id])
    coupon = Coupon.find_by(code: coupon_code, active: true)

    if @cart.nil? || coupon.nil?
      flash[:coupon_error] = "Invalid or inactive coupon."
      session.delete(:applied_coupon_id)
      redirect_to cart_path and return
    end

    order = @cart.order
    @cart_items = order.order_products.includes(:product)

    matching_items = @cart_items.select { |item| item.product.coupon_id == coupon.id }

    if matching_items.any?
      session[:applied_coupon_id] = coupon.id
      flash[:coupon_success] = "Coupon applied! #{coupon.discount}% off will be shown."
    else
      session.delete(:applied_coupon_id)
      flash[:coupon_error] = "Coupon code does not apply to any item in your cart."
    end

    redirect_to cart_path
  end





  def add_to_cart
    authorize @product, :add_to_cart?

    if @product.stock <= 0
      redirect_to product_path(@product), alert: "This product is out of stock."
      return
    end
    cart =
      if user_signed_in?
        current_user.carts.order(created_at: :desc).first || current_user.carts.create!
      else
        find_or_create_guest_cart
      end
    cart.save! unless cart.persisted?

    session[:cart_id] = cart.id unless user_signed_in?
    order = cart.order
    if order.nil?
      order = Order.new(cart: cart, status: false)
      order.user = current_user if user_signed_in?
      order.save!
    end
    order_product = order.order_products.find_or_initialize_by(product_id: @product.id)
    if order_product.new_record? || @product.stock > order_product.quantity
      order_product.quantity ||= 0
      order_product.quantity += 1
      order_product.save!
    else
      redirect_to product_path(@product), alert: "Not enough stock available."
      return
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to product_path(@product), notice: "Product added to cart." }
    end
  end
  def remove_item
    @order_product = OrderProduct.find(params[:id])
    @order_product.destroy
    if session[:applied_coupon_id]
      order = @order_product.order
      still_applicable = order.order_products.any? do |item|
        item.product.coupon_id == session[:applied_coupon_id]
      end

      session.delete(:applied_coupon_id) unless still_applicable
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Item removed from cart." }
    end
  end
  def update_quantity
    @order_product = OrderProduct.find(params[:id])
    new_quantity = params[:order_product][:quantity].to_i
    product_stock = @order_product.product.stock

    if new_quantity <= 0
      @order_product.destroy
    elsif new_quantity <= product_stock
      @order_product.update(quantity: new_quantity)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
  def calculate_totals_with_coupon(cart, coupon)
    @original_total = 0
    @discounted_total = 0

    order = cart.order
    return unless order

    order.order_products.includes(:product).each do |item|
      price = item.product.price * item.quantity
      @original_total += price

      if item.product.coupon_id == coupon.id
        discounted_price = price * (1 - coupon.discount.to_f / 100)
        @discounted_total += discounted_price
      else
        @discounted_total += price
      end
    end
  end
end
