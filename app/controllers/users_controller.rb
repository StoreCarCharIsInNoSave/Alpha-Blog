class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find(params[:id])
    session[:user_id] = nil if current_user == @user
    #articles = @user.articles
    #articles.each do |article|
    #    article.destroy
    #end
    @user.destroy
    flash[:notice] = "User and all articles created by user have been deleted"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Hello #{@user.username}, Welcome to the ALPHA BLOG!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  private def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def edit

  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own account"
      redirect_to root_path
    end
  end
end
