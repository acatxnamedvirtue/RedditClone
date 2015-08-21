class PostsController < ApplicationController
  before_action :ensure_author, only: [:edit, :update, :destroy]
  skip_before_action :ensure_logged_in, only: :show

  def show
    @post = Post.find(params[:id])
    @all_comments = @post.comments_by_parent_id
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      flash[:notice] = "Thanks for creating a new Post!"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = "Thanks for editing your Post!"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
    current_user.posts.find(params[:id]).destroy!
    redirect_to :root
  end

  def upvote
    post = Post.find(params[:id])
    vote(1, post)
    redirect_to post
  end

  def downvote
    post = Post.find(params[:id])
    vote(-1, post)
    redirect_to post
  end

  private

  def vote(value, post)
    vote = post.votes.find_by(voter_id: current_user.id)
    unless vote
      post.votes.create!(voter_id: current_user.id, value: value)
    else
      vote.destroy!
    end
  end

  def ensure_author
    redirect_to :root unless Post.find(params[:id]).author == current_user
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
