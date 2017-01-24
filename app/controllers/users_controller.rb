class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # brisanje jmbg-a cu za sada staviti ovde jer neznam kako da na klik i pozovem poseban metod 
    # i da mu passujem parametar
    izbrisijmbg
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
     log_in @user
     flash[:success] = "Welcome to the App!"
     redirect_to @user #redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def izbrisijmbg
      x = []
        
        unless params[:jmbg_param] == nil
        
        puts params[:jmbg_param]
            jmbg_za_brisanje = params[:jmbg_param]
          
            if jmbg_za_brisanje.length == 13
                
                x << Company.where("clanovi LIKE ?", "%#{jmbg_za_brisanje}%")
                x << Company.where("zastupnici LIKE ?", "%#{jmbg_za_brisanje}%")
              
                mbovi = []
                x.each do |y|
                    y.each do |z|
                    mbovi << z.MB
                    end
                end
                
                mbovi.each do |m|
                    Company.where(mb: m).destroy_all
                puts "destroyed"
                end
            
            end    
        end
        
        #neka izadje cist iz metoda
        params.delete :jmbg_param
        
    end
end
