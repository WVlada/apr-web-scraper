class SessionsController < ApplicationController
  
  def new
    chech_if_admin_exists_and_create_if_no
  end
  
  def create
  
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    
    end
  
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  private
  
  def chech_if_admin_exists_and_create_if_no
    user = User.find_by(admin: 1)
    if user
    # ok postoji vec
    else
    # napravi admina
      x =  User.create(name: ENV["ADMIN_USERNAME"], 
                       password: ENV["ADMIN_PASSWORD"],
                       email: ENV["ADMIN_EMAIL"],
                       admin: 1,
                       id: 1)
      x.save!
    end
  end

end
