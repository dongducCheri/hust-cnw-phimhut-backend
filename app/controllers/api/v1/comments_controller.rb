class Api::V1::CommentsController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:index]
  before_action :set_movie, only: [:index, :create]
  before_action :set_comment, only: [:destroy]
  # GET /api/v1/movies/:movie_id/comments
  def index
    comments = @movie.comments.includes(:user).order(created_at: :desc)
    
    render json: {
      data: CommentSerializer.new(comments).serializable_hash
    }, status: :ok
  end
  
  # POST /api/v1/movies/:movie_id/comments
  def create
    comment = @movie.comments.new(comment_params)
    comment.user = current_user
    if comment.save
      render json: {
        message: "Bình luận thành công",
        data: CommentSerializer.new(comment).serializable_hash
      }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id
  def destroy 
    unless @comment.user_id == current_user.id || current_user.admin?
      render json: {error: "No permission!"}, status: :forbidden
      return 
    end

    @comment.destroy!
    render json: {message: "Comment deleted!"}, status: :ok
  end

  
  private 
  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])
    unless @movie
      render json: { error: "Film not found" }, status: :not_found and return
    end
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      render json: { error: "Comment not found" }, status: :not_found and return
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end


end
