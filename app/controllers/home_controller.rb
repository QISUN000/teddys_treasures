class HomeController < ApplicationController
  def index
    @featured_products = Product.where(on_sale: true).limit(4)
    @categories = Category.all
    
    # Display session info in view
    @last_visit = session[:last_visit]
    @visit_count = session[:visit_count]
    
    # Use custom flash types for product recommendations
    if @featured_products.any? && session[:visit_count] > 1
      flash.now[:warning] = "Don't miss our featured products on sale!"
    end
  end
end