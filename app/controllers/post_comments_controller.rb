class PostCommentsController < ApplicationController
  before_action :find_post

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    @comment.save

    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  private
  def find_post
    @post = Post.find(params[:post_id])
  end
  def comment_params
    params.require(:comment).permit(:content)
  end
end
