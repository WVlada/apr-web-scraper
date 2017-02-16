require 'set'
class CompaniesController < ApplicationController
include ApplicationHelper
include CompaniesHelper

  def index
    @company = Company.all
  end
  
  def show
    @company = Company.find(params[:id])
    gon.companies = []
    Company.limit(10).each do |x|
      gon.companies << precisti_ime(x.poslovno_ime)
    end
    
    # jer mi trebaju samo njihovi MB-ovi za grafik
    gon.povezani = []
    x = pretraga_povezanih(@company)
    x.each do |y|
      gon.povezani << y.mb
    end
    gon.kombinacije = gon.povezani.combination(2)
  
  end

  def search
    unless params[:x].nil? || params[:x].empty? 
    @companies = Set.new
      begin
   
      case params[:search_param]
        when "ime", "prezime", "jmbg"
          @clanovi = Company.where("clanovi LIKE ?", "%#{params[:x]}%")
          @zastupnici = Company.where("zastupnici LIKE ?", "%#{params[:x]}%")
          @ostali_zastupnici = Company.where("ostali_zastupnici LIKE ?", "%#{params[:x]}%")
          @nadzorni_odbor = Company.where("nadzorni_odbor LIKE ?", "%#{params[:x]}%")
          @upravni_odbor = Company.where("upravni_odbor LIKE ?", "%#{params[:x]}%")
          #my_array.push(item1) unless my_array.include?(item1) - performanse issues??
          # resio sam sa SET varijablom a ne ARRAY
          @clanovi.each do |x|
            @companies << x
          end
          @zastupnici.each do |x|
            @companies << x
          end
          @ostali_zastupnici.each do |x|
            @companies << x
          end
          @nadzorni_odbor.each do |x|
            @companies << x
          end
          @upravni_odbor.each do |x|
            @companies << x
          end
          
        when "ime_firme"
          @companies = Company.where("poslovno_ime LIKE ?", "%#{params[:x]}%")
        when "mb"
          x = Company.find_by(params[:search_param] => params[:x])
          unless x == nil
            @companies << x
          end
        when "pib"
          y = Company.find_by(params[:search_param] => params[:x])
          unless y == nil
            @companies << y
          end
      end
      
      rescue
      
      end
      
    end
  end
#  def new
#    @company = Company.new(company_params)
#  end
  
#  def create
#    @company = Company.new(company_params)
#    @company.save
    #MAKE A LOG ENTRY
#  end
  
  
  private

#    def company_params
#      params.require(:company).permit(:mb) 
                                      #:poslovno_ime,
                                      #:status,
                                      #:pravna_forma,
                                      #:opstina,
                                      #:mesto,
                                      #:ulica_i_broj,
                                      #:datum_osnivanja,
                                      #:PIB,
                                      #:sifra_delatnosti,
                                      #:naziv_delatnosti,
                                      #:zastupnici,
                                      #:ostali_zastupnici,
                                      #:nadzorni_odbor,
                                      #:upravni_odbor,
                                      #:clanovi)
#    end
end
