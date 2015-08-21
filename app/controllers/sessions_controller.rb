class SessionsController < ApplicationController
  skip_before_action :ensure_logged_in, except: :destroy

  def new
    @username = ""
  end

  def create
    user = User.find_by_credentials(params[:user][:username],
                                     params[:user][:password])
    if user
      log_in_user!(user)
      flash[:notice] = "So good to see you back!"
      redirect_to :root
    else
      flash.now[:errors] = ["Invalid username and/or password"]
      @username = params[:user][:username]
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to new_session_url
  end
end
