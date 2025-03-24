class HomeController < ApplicationController
  def index
    @featured_products = Product.where(on_sale: true).limit(4)
    @categories = Category.all
  end
end