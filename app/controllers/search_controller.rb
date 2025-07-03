class SearchController < ApplicationController
  def products
    results = Product.search(params[:q], hitsPerPage: 5, attributesToHighlight: [])
    render json: results.map { |hit|
      {
        id: hit["id"],
        label: hit["product_name"],
        url:  product_path(hit["id"])
      }
    }
  end
end
