class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_product, only: [ :update, :destroy, :show, :edit ]
  # before_action :authorize_product, only: [ :edit, :update, :destroy ]

  def index
    @products = Product.all
  end

  def new
    if user_signed_in? && current_user.has_role?(:buyer)
      current_user.add_role(:seller)
    else
      redirect_to new_user_registeration_path, alert: "Please sign up firts to login"
    end
    @product = Product.new
  end

  def create
    @product= current_user.products.build(product_params)
    if @product.save
      redirect_to products_path, notice: "product created successfully"
    else
    render :new, status: :unprocessable_entity
    end
  end

  def show
  end
  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      redirect_to new_product_path, notice: "Product updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to products_path, notice: "Product deleted."
  end
  def category
  @category = params[:category]
  @products = Product.where(category: @category)
  render :index
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  # def authorize_product
  #   authorize @product
  # end

  def product_params
    params.require(:product).permit(:product_name, :description, :price, :coupon_id, :category, images: [])
  end
end
