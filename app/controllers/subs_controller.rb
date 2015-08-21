class SubsController < ApplicationController
  before_action :ensure_moderator, only: [:edit, :update, :destroy]
  skip_before_action :ensure_logged_in, only: [:show, :index]

  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = current_user.subs.new(sub_params)

    if @sub.save
      flash[:notice] = "Thanks for creating a new Sub!"
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = current_user.subs.find(params[:id])
  end

  def update
    @sub = current_user.subs.find(params[:id])

    if @sub.update(sub_params)
      flash[:notice] = "Thanks for editing your Sub!"
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    current_user.subs.find(params[:id]).destroy!
    redirect_to :root
  end

  private

  def ensure_moderator
    redirect_to :root unless Sub.find(params[:id]).moderator == current_user
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
