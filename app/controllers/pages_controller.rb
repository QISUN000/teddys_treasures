class PagesController < ApplicationController
  def about
    @page = Page.find_by(slug: 'about')
  end

  def contact
    @page = Page.find_by(slug: 'contact')
  end
  
  def faq
    @page = Page.find_by(slug: 'faq')
  end
end