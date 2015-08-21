class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Welcome to the site!"
      log_in_user!(@user)
      redirect_to user_url(@user)#subs_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = "You've edited yourself!"
      redirect_to user_url(@user)#subs_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    log_out!
    User.find(params[:id]).destroy!
    redirect_to new_user_url
  end

  private
  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
