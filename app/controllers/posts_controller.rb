class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
    # byebug
    @post = current_user.posts.build
  end

  def create
    # byebug
    # puts "Params: #{params.inspect}"
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: 'Post created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @post = Post.find(params[:id])
    @comments = @post.comments.includes(:replies)
    @comment = Comment.new
  end


  def edit
    
  end

 
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully deleted.'
  end
  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image, :video, :title)
  end
end
