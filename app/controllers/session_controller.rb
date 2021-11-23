class SessionController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:notice] = "You have successfully logged in"
        redirect_to user_path(user)
    else
        flash[:danger] = 'Invalid email/password combination'
        redirect_to login_path
    end
  end
 
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out"
    redirect_to root_path
  end

end