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
    @auth_user = AuthUser.find(params[:id])
    @auth_user_details =  @auth_user.auth_user_detail()
    # return render plain: @auth_user.inspect
  end

  def new
    @auth_user = AuthUser.new
    #
    # [NOTE]
    # - If you ommit AuthUserDetail.new, user detail fields do not appear of first request.
    #   But they do appear after form submission.
    #   Find out why this happens.
    #

    # The following are the same. Probably 'build' prefix works as an alias (?).
    # @auth_user.build_auth_user_detail
    @auth_user.auth_user_detail = AuthUserDetail.new
  end

  def create

    #
    # Passing this hardcoded object instead of user_params populates both tables
    #
    params = {
      email: "delasthanos@gmail.com",
      password_digest: "delasthanos@gmail.com",
      auth_user_detail_attributes: {
        firstname: "thanos",
        lastname: "delas"
      }
    }    

    @auth_user = AuthUser.new(user_params)
    @auth_user.auth_user_detail = AuthUserDetail.new(user_params[:auth_user_detail_attributes])

    if @auth_user.save
      flash[:success] = "User created successfully"
      redirect_to action: "index"
    else      
      render 'new'
    end

  end

  def edit
    @auth_user = AuthUser.find(params[:id])
    @auth_user_details =  @auth_user.auth_user_detail()
    # return render plain: @auth_user.inspect
    # @auth_user_details = @auth_user.auth_user_detail()
    # return render plain: @auth_user_details.inspect
    # @auth_user.build_auth_user_detail(:firstname => "go", :lastname => "go2")
    # @auth_user.auth_user_detail.find(params[:id])
    # return render plain: @auth_user.inspect
  end

  def update
    @auth_user = AuthUser.find(params[:id])    

    if @auth_user.update(user_params)
      flash[:success] = "User updated successfully"
      redirect_to @auth_user
    else
      render :edit
    end

  end

  def destroy
    @auth_user = AuthUser.find(params[:id])
    @auth_user.auth_user_detail.destroy
    @auth_user.destroy

    flash[:danger] = "User with email "+@auth_user.email+" deleted successfully"
    redirect_to auth_users_path
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

    # params.require(:auth_user).permit(:email, :password_digest)
    # return params.require(:auth_user).permit!
    params.require(:auth_user).permit(
      :email,
      :password_digest,
      auth_user_detail_attributes: [:id, :firstname, :lastname]
    )
  end

end