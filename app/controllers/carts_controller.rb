class CartsController < ApplicationController
  before_action :set_product, only: [ :add_to_cart ]

  def show
    @order = current_cart.order
    @cart_items = @order&.order_products&.includes(:product) || []
  end

  def add_to_cart
    authorize @product, :add_to_cart?

    if @product.stock <= 0
      redirect_to product_path(@product), alert: "This product is out of stock."
      return
    end

    cart = current_user&.carts&.first || Cart.find_by(id: session[:cart_id])
    cart ||= Cart.create(user: current_user)
    session[:cart_id] ||= cart.id

    order = cart.order || cart.create_order(user: current_user, status: false)

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

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to cart_path, notice: "Item removed from cart." }
  end
  end
def update_quantity
  @order_product = OrderProduct.find(params[:id])
  new_quantity = (params[:order_product]&.[](:quantity) || params[:quantity]).to_i
  product_stock = @order_product.product.stock

  if new_quantity <= 0
    @order_product.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Item removed from cart." }
    end
  elsif new_quantity <= product_stock
    @order_product.update(quantity: new_quantity)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Quantity updated." }
    end
  else
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = "Only #{product_stock} item(s) in stock."
        render turbo_stream: turbo_stream.replace(
          "cart_alert",
          partial: "carts/alert",
          locals: { message: "Only #{product_stock} item(s) in stock." }
        )
      end
      format.html { redirect_to cart_path, alert: "Only #{product_stock} item(s) in stock." }
    end
  end
end





  private

  def set_product
    @product = Product.find(params[:id])
  end

  def current_cart
    user_signed_in? ? current_user.carts.last : Cart.find_by(id: session[:cart_id])
  end
end
