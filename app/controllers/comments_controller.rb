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
  

  # def new
  #   # @comment = @post.comments.build
  #   @comment = Comment.new
  #   @parent_comment = Comment.find(params[:comment_id]) if params[:comment_id]
  # end

  # def create
  #   # byebug
  #   @comment = @post.comments.build(comment_params)
  #   @comment.user = current_user # Assuming you have authentication in place
  #   @comment.post = @post
  #   if @comment.save
  #     redirect_to post_path(@post), notice: 'Comment added successfully'
  #   else
  #     redirect_to post_path(@post), alert: 'Failed to add comment'
  #   end
  # end

  def new
    @comment = Comment.new
    # @parent_comment = Comment.find(params[:comment_id]) if params[:comment_id]
  end
  
  def create
    
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    # if params[:comment][:parent_comment_id].present?
    #   parent_comment = Comment.find(params[:comment][:parent_comment_id])
    #   @comment.commentable = parent_comment.commentable
    #   # @comment.parent_comment = parent_comment
    # else
      # @comment.commentable = @post
    # end
    # byebug
    # if params.dig(:comment, :comment_id).present? && params.dig(:comment, :reply_id).present?
    #   @reply = Comment.find(params[:comment][:reply_id])
    #   @comment.commentable = @reply
    if params.dig(:comment, :comment_id).present?
      parent_comment = Comment.find(params[:comment][:comment_id])
      @comment.commentable = parent_comment
    else
      @comment.commentable = @post
    end

    if @comment.save
      redirect_to post_path(@post), notice: 'Comment added successfully'
    else
      redirect_to post_path(@post), alert: 'Failed to add comment'
    end
  end

  # def reply
  #   byebug
  #   comment = Comment.find(params[:id])
  #   @comment = @post.comments.build(comment_params)
  #   @comment.user = current_user
  #   @comment.commentable = comment
  #   if @comment.save
  #     redirect_to post_path(@post), notice: 'Comment added successfully'
  #   else
  #     redirect_to post_path(@post), alert: 'Failed to add comment'
  #   end
  # end

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
    params.require(:comment).permit(:comment, :post_id, :commentable_id, :commentable_type, :comment_id)
  end
end
