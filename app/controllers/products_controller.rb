class ProductsController < ApplicationController
  def index
    @products = Product.all.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
    @related_products = @product.categories.flat_map(&:products).uniq - [@product]
    @related_products = @related_products.sample(4)
  end

  def category
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(12)
    render :index
  end

  def search
    @query = params[:query]
    @category_id = params[:category_id]
    
    @products = Product.where("name ILIKE ? OR description ILIKE ?", "%#{@query}%", "%#{@query}%")
    
    if @category_id.present? && @category_id != "all"
      @category = Category.find(@category_id)
      @products = @products.joins(:categories).where(categories: { id: @category_id })
    end
    
    @products = @products.page(params[:page]).per(12)
    render :index
  end
end