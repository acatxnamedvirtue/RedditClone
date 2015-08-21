class CommentsController < ApplicationController
  def create
    comment = current_user.comments.new(comment_params)

    if comment.save
      flash[:notice] = "Thanks for commenting."
    else
      flash[:errors] = comment.errors.full_messages
    end
    redirect_to comment.post
  end

  def destroy
    comment = current_user.comments.find(params[:id]).destroy!
    redirect_to comment.post
  end

  def upvote
    comment = Comment.find(params[:id])
    vote(1, comment)
    redirect_to comment.post
  end

  def downvote
    comment = Comment.find(params[:id])
    vote(-1, comment)
    redirect_to comment.post
  end

  private

  def vote(value, comment)
    vote = comment.votes.find_by(voter_id: current_user.id)
    unless vote
      comment.votes.create!(voter_id: current_user.id, value: value)
    else
      vote.destroy!
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
