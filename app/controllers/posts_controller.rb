class PostsController < ApplicationController

  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def create
    @post = current_user.posts.build(params[:micropost])
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def correct_user
    @post = current_user.posts.find_by_id(params[:id])
    redirect_to root_path if @post.nil?
  end
end
