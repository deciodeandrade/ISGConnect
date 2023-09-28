class PostsController < ApiController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/1
  def show; end

  # POST /posts
  def create
    @post = Post.new(post_params)
    save_post!
  end

  # PATCH/PUT /posts/1
  def update
    @post.attributes = post_params
    save_post!
  end

  # DELETE /posts/1
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
