class PostsController < ApiController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.paginate(page: params[:page], per_page: 10)
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
