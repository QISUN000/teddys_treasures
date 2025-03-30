class PagesController < ApplicationController
  def about
    @page = Page.find_by(slug: 'about')
    render :show
  end
  
  def contact
    @page = Page.find_by(slug: 'contact')
    render :show
  end
  
  def faq
    @page = Page.find_by(slug: 'faq')
    render :show
  end
  
  def show
    @page = Page.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Page not found"
  end
end