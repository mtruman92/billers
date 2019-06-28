class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :password))

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end


   # If not logged_in? Load Signup form, else load user index #
   get '/signup' do
     if !logged_in?
       erb :'/users/new.html'
     else
       redirect '/bills'
     end
   end

   # If: any empty fields => load /signup again. Else: Create the user with params, assign session[:user_id] to user, load /users #
   post '/signup' do
      if logged_in?
        flash[:notice] = "You were already logged in. Here are your patterns."
        redirect to '/bills'
      elsif params[:username] == "" || params[:password] == ""
        flash[:notice] = "In order to sign up for account, you must have both a username & a password. Please try again."
        redirect to '/signup'
      else
        @user = User.create(username:params[:username], email:params[:email], password:params[:password])
        @user.save
        session[:user_id] = @user.id
        redirect to '/bills'
      end
    end

   # If logged_in? redirect to /bills, otherwise redirect to /login
   get '/login' do
     if logged_in?
       redirect '/bills'
     else
       erb :'/login'
     end
   end

   # Find user by username, if exists && password is authenticated, assign session[:user_id] to user, load /users. Else: load /login #
   post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/bills'
    else
      redirect '/login'
    end
  end

   # If logged_in?: Logout, redirect to /login. Else redirect to / #
   get '/logout' do
     if logged_in?
       logout!
       redirect '/login'
     else
       redirect '/'
     end
   end

   # GET: /users
   get "/users" do
     if logged_in?
       erb :'/users/index.html'
     else
       redirect '/login'
     end
   end

  # lets an user edit info only if logged in
  get '/users/:id/edit' do
    if logged_in?
        erb :'users/edit_user'
    else
      redirect '/login'
    end
  end

  # does not let a user edit with blank content
  patch '/users/:id' do
    if !params[:username].empty?  && !params[:password].empty?
      @user = User.find(params[:id])
      @user.update(username:params[:username], password:params[:password])
      redirect to "/users/current_user"
    else
      redirect to "/users/#{params[:id]}/edit"
    end
  end


  # displays user info if logged in
   get '/users/:id' do
    if logged_in?
      erb :'users/show'
    else
      redirect '/login'
    end
  end

  # lets a user delete its own account if they are logged in
  delete '/users/:id/delete' do
    if logged_in?
      current_user.delete
      redirect to "/logout"
    else
      redirect_if_not_logged_in
    end
  end

 end
