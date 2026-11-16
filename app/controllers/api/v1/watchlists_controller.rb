class Api::V1::WatchlistsController < Api::V1::BaseController
  # GET /api/v1/watchlists
  def index
    movies_relation = current_user.watchlist_movies.where(is_published: true)

    # Filetering tab by param status
    if params[:status].present? && Watchlist.statuses.key?(params[:status])
      movies_relation = movies_relation.where(watchlists: { status: params[:status] })
    end

    # Ordering 
    movies_relation = movies_relation.order("watchlists.updated_at DESC")
    pagy, paginated_movies = pagy(movies_relation)

    render json: {
      total: pagy.count,
      total_pages: pagy.pages,
      page: pagy.page,
      limit: pagy.limit,
      data: MovieSummarySerializer.new(paginated_movies).serializable_hash
    }, status: :ok
  end

  # POST /api/v1/watchlists (Bấm nút Bookmark trên trang chi tiết để lưu/đổi trạng thái)
  # Body: { "movie_id": 1, "status": "watching" }
  def create
    movie = Movie.find_by(id: params[:movie_id], is_published: true)
    return render json: { error: "Movie not found" }, status: :not_found unless movie

    watchlist = current_user.watchlists.find_or_initialize_by(movie: movie)
    watchlist.status = params[:status] if params[:status].present?

    if watchlist.save
      render json: {
        message: "Cập nhật danh sách thành công",
        status: watchlist.status,
        movie_id: watchlist.movie_id
      }, status: :ok
    else
      render json: { errors: watchlist.errors.full_messages }, status: :unprocessable_entity
    end
  end
end