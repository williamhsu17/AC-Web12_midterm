class PostsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :set_post, :only => [:edit, :show, :update, :destroy]

  Num_posts_per_page = 10

  def index
    if params[:status] == "new"
      @post = Post.new
    elsif params[:status] == "update"
      set_post
    end

    if params[:page]
      @total_page = Post.all.page(1).per(Num_posts_per_page).total_pages
      params[:page] = @total_page if params[:page].to_i > @total_page
    end

    @posts = Post.page(params[:page]).per(Num_posts_per_page)
    @posts = @posts.includes(:user,:category)
  end

  def new
    redirect_to posts_path( :status => :new,
                            :set_post_path => posts_path,
                            :set_method => :post)
  end

  def edit
    redirect_to posts_path( :id => params[:id],
                            :status => :update,
                            :set_post_path => post_path(@post),
                            :set_method => :patch)
  end

  def show
    #  if @post.comments 沒有這行頂多是空陣列
    @comments = @post.comments.includes(:user)
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "新增主題成功"
      redirect_to posts_path
    else
      render new_post_path
    end
  end

  def update
    # 沒有針對是不是自己做驗證 任何人都可以修改其他人的文章
    if @post.update(post_params)
      redirect_to post_path(@post)
      flash[:notice] = "更新成功"
    else
      render "posts/edit"
    end
  end

  def destroy
    # 沒有針對是不是自己做驗證 任何人都可以刪除其他人的文章
    @post.destroy
    redirect_to posts_path(:page => params[:page])
    flash[:alert] = "刪除成功"
  end

  private
  def post_params
    params.require(:post).permit( :name, :content, :category_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
