class Api::V1::CommentsController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:index]
  before_action :set_movie
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

  private 
  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])
    unless @movie
      render json: { error: "Film not found" }, status: :not_found and return
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
