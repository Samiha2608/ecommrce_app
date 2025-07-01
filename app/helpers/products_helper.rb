module ProductsHelper
  def product_categories
    Product.distinct.pluck(:category).compact.sort.map { |category| [ category.titleize, category ] }
  end

  def products_heading(category)
    category.present? ? "#{category.titleize} Products" : "All Products"
  end

  def product_image_with_discount(product)
    return unless product.images.attached?

    image_html = image_tag(
      product.images.first.variant(resize_to_limit: [ 200, 200 ]),
      class: "card-img-top fixed-image",
      alt: "Product Image"
    )

    badge_html =
      if product.coupon&.discount.present?
        content_tag(:span, "#{product.coupon.discount}% OFF",
          class: "badge bg-danger position-absolute top-0 end-0 m-2 p-2")
      end

    content_tag(:div, image_html.concat(badge_html.to_s).html_safe, class: "position-relative")
  end
end
