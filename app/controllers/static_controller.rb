class StaticController < ApplicationController

  def home
    
  end

  def srpski
    params[:locale] = :sr
    render "#{params[:controller]}\##{params[:action]}"
  end

  def english
    params[:locale] = :en
    render "#{params[:controller]}\##{params[:action]}"
  end
  
  def espanol
    params[:locale] = :es
    render "#{params[:controller]}\##{params[:action]}"
  end

  def help
  end

  def about
    @svitipovikompanija = CompanyType.all
    # ima mnogo zanimljivih skracenica
    @brojkompanija = CompanyType.sum(:number)
    
    @sectors = Sector.order(:sum).reverse_order.all
    @brojsektora = Sector.count
    
    @brojfizickihlica = Person.count
    
    @fizickalica = Person.page(params[:page]).per(30).order('ukupno DESC')
    
  end

  def contact
  end
  
  def info
   
  end
  
end
