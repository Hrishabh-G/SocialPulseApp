class CommentsController < ApplicationController
  before_action :find_post

  # def index
  #   # byebug
  #   # @comments = @post.comments.includes(:replies)
  #   @comments = Comment.all
  #   @comment = Comment.new
  #   @post ||= Post.find(params[:post_id])
  # end

  def index
    @comments = @post.comments
    @comment = Comment.new
  end

  # def index
  #   @comments = Comment.all
  #   @comment = Comment.new
  #   @reply = Reply.new
  # end
  

  def new
    # @comment = @post.comments.build
    @comment = Comment.new
    @parent_comment = Comment.find(params[:comment_id]) if params[:comment_id]
  end

  def create
    # byebug
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user # Assuming you have authentication in place
    @comment.post = @post
    if @comment.save
      redirect_to post_path(@post), notice: 'Comment added successfully'
    else
      redirect_to post_path(@post), alert: 'Failed to add comment'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@comment.post), notice: 'Comment deleted successfully'
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  # def comment_params
  #   params.require(:comment).permit(:content)
  # end

  # def create
  #   @comment = current_user.comments.build(comment_params)
  #   if @comment.save
  #     flash[:notice] = 'Comment added successfully'
  #   else
  #     flash[:error] = 'Failed to add comment'
  #   end
  #   redirect_back(fallback_location: root_path)
  # end

#   private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :commentable_id, :commentable_type, :parent_comment_id)
  end
end
