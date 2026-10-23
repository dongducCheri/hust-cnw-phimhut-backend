class Api::V1::GenresController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:index, :show]
  #GET /api/v1/genres
  def index
    genres = Genre.order(id: :asc)
    render json:{
      total: genres.count,
      data: genres.select(:id, :name, :slug, :tmdb_genre_id).as_json
    }, status: :ok
  end

  # GET /api/v1/genres/:id
  def show
    genre = Genre.find_by(id: params[:id]) || Genre.find_by(slug: params[:id])
    if genre 
      render json: {
        id: genre.id,
        name: genre.name,
        slug: genre.slug,
        tmdb_genre_id: genre.tmdb_genre_id
      }, status: :ok
    else
      render json: { error: "Genre not found" }, status: :not_found
    end
  end
end
