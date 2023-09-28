class PostsController < ApiController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show; end

  def create
    @post = Post.new(post_params)
    save_post!
  end

  def update
    @post.attributes = post_params
    save_post!
  end

  def destroy
    @post.destroy
  rescue
    render_error(fields: @post.errors.messages)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :text, :user_id)
    end

    def save_post!
      @post.save!
      render :show
    rescue
      render_error(fields: @post.errors.messages)
    end
end
