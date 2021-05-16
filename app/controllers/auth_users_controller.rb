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

  def generate_users
    users = AuthUser.all()
    users.destroy_all()

    14.times { |i| 

      user_email = "user#{i}@example.com"
      user_passowrd = (0...50).map { ('a'..'z').to_a[rand(26)] }.join

      user = AuthUser.new("email": user_email, "password_digest": user_passowrd)
      if !user.save()
        flash[:danger] = "Could not generate users: "+user.errors.messages.inspect+user.errors.full_messages.inspect
        return redirect_to action: "index"
      end
    }

    flash[:success] = "Users created successfully"

    return redirect_to action: "index"

  end

  private def user_params
    params.require(:auth_user).permit(:email, :passowrd)
  end

end