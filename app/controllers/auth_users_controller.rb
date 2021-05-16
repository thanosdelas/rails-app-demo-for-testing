#auth_users
class AuthUsersController < ApplicationController

  def initialize
    super
    @page = "users"
  end

  def index
    @auth_users = AuthUser.all()
  end

  def show
    @user = AuthUser.find(params[:id])
  end

  def new
    @auth_user = AuthUser.new
  end

  def create

    @auth_user = AuthUser.new(user_params)

    if @auth_user.save
      flash[:success] = "User created successfully"
      redirect_to action: "index"
    else
      render 'new'
    end

  end

  private def user_params
    params.require(:auth_user).permit(:email, :passowrd)
  end

end