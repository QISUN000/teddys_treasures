class ProductsController < ApplicationController
  def index
    @products = Product.all
    
    if params[:category_id].present?
      @category = Category.find_by(id: params[:category_id])
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] }) if @category
    end
    
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
  
  def search
    @query = params[:query]
    @categories = Category.all
    
    @products = Product.all
    
    # Filter by query if present
    if @query.present?
      @products = @products.where("products.name ILIKE ? OR products.description ILIKE ?", "%#{@query}%", "%#{@query}%")
    end
    
    # Filter by category if selected
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end
    
    # Paginate results
    @products = @products.page(params[:page]).per(12)
    
    render :index
  end
end