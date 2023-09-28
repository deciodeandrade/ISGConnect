class CommentsController < ApiController
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    @comments = Comment.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def create
    @comment = Comment.new(comment_params)
    save_comment!
  end

  def update
    @comment.attributes = comment_params
    save_comment!
  end

  def destroy
    @comment.destroy
  rescue
    render_error(fields: @comment.errors.messages)
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:name, :text, :post_id)
    end

    def save_comment!
      @comment.save!
      render :show
    rescue
      render_error(fields: @comment.errors.messages)
    end
end
