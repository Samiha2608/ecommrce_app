module ProductsHelper
  def product_categories
    Product.distinct.pluck(:category).compact.sort.map { |category| [ category.titleize, category ] }
  end

  def products_heading(category)
    category.present? ? "#{category.titleize} Products" : "All Products"
  end

  def product_image(product)
    return unless product.images.attached?

    image_html = image_tag(product.images.first, class: "card-img-top fixed-image", alt: "Product Image")
  end
end
