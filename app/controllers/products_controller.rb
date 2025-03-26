class ProductsController < ApplicationController
  def index
    @products = Product.all
    
    # Filter by category
    if params[:category_id].present?
      @category = Category.find_by(id: params[:category_id])
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] }) if @category
    end
    
    # Filter by status
    if params[:filter].present?
      case params[:filter]
      when 'on_sale'
        @products = @products.where(on_sale: true)
      when 'new'
        @products = @products.where('created_at >= ?', 1.month.ago)
      when 'updated'
        @products = @products.where('updated_at >= ?', 1.week.ago)
      end
    end
    
    # Search by keyword
    if params[:query].present?
      @query = params[:query].strip
      @products = @products.where("name ILIKE ? OR description ILIKE ?", "%#{@query}%", "%#{@query}%")
    end
    
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      redirect_to products_path, alert: "Product not found" and return
    end
    
    @related_products = @product.categories.flat_map(&:products).uniq - [@product]
    @related_products = @related_products.sample(4) if @related_products.any?
  end

  def category
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(12)
    render :index
  end
end