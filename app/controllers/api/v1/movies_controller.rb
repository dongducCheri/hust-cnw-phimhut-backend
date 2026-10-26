class Api::V1::MoviesController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:index, :show]

  # GET /api/v1/movies
  def index
    movies_relation = MoviesQuery.new(params).call.distinct
    pagy, paginated_movies = pagy(movies_relation)

    render json: {
      total: pagy.count,
      total_pages: pagy.pages,
      page: pagy.page,
      limit: pagy.limit,
      data: MovieSummarySerializer.new(paginated_movies).serializable_hash
    }, status: :ok
  end

  # GET /api/v1/movies/:id
  def show
    movie = Movie.includes(:genres, :episodes, movie_credits: :person).where(is_published: true).find_by(id: params[:id])
    if movie
      render json: MovieDetailSerializer.new(movie).serializable_hash, status: :ok
    else
      render json: { error: "Movie not found" }, status: :not_found
    end
  end
end