class IzbrisijmbgController < ApplicationController
    def create
        x = []
        puts "***************"
        unless params[:jmbg_param] == nil
        puts params[:jmbg_param]
            jmbg_za_brisanje = params[:jmbg_param]
          
            if jmbg_za_brisanje.length == 13
                
                x << Company.where("clanovi LIKE ?", "%#{jmbg_za_brisanje}%")
                x << Company.where("zastupnici LIKE ?", "%#{jmbg_za_brisanje}%")
              
                mbovi = []
                x.each do |y|
                    y.each do |z|
                    mbovi << z.mb
                    end
                end
                
                mbovi.each do |m|
                    Company.where(mb: m).destroy_all
                puts "destroyed"
                end
            
            end    
        end
        
        redirect_to :back
    end

def index
    redirect_to :back
end

end