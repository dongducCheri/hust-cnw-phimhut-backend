class Api::V1::GenresController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:index, :show]
  #GET /api/v1/genres
  def index
    genres = Genre.order(id: :asc)
    render json:{
      total: genres.count,
      data: GenreSerializer.new(genres).serializable_hash
    }, status: :ok
  end

  # GET /api/v1/genres/:id
  def show 
    genre = Genre.find_by(id: params[:id]) || Genre.find_by(slug: params[:id])
    if genre
      render json: GenreSerializer.new(genre).serializable_hash, status: :ok
    else
      render json: { error: "Genre not found" }, status: :not_found
    end
  end
end
