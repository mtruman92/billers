require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
      set :views, 'app/views'
      enable :sessions
      set :session_secret, 'password_security'
  end


get '/' do
  erb :index
end


## Helpers ##

private

helpers do

  # Double bang current_user means they aren't logged in #
  def logged_in?
    !!current_user
  end

  # Find the current_user by finding their session[:user_id] if one exists #
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Logout method to clear the session #
  def logout!
    session.clear
  end
  
   def create
    @user = User.find_by(email: params[:session][:username].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to '/login'
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end


end


end
