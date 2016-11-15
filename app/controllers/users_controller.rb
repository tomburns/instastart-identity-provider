class UsersController < ApplicationController
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: { users: @users } }
    end
  end

  def show
    find_user
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def create
    @user = User.create(user_params)
    redirect_to @user
  end

  def edit
    find_user
  end

  def update
    find_user
    if @user.update_attributes(user_params)
      render 'show'
    else
      render text: 'Error updating user fields'
    end
  end

  private
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :display_name, :first_name, :last_name, :password)
  end
end
