class Api::V1::MoviesController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:index, :show]

  # GET /api/v1/movies
  def index
    movies = Movie.where(is_published: true).includes(:genres)

    # 1. Search by title or original title with relevance sorting (?q=Buddy)
    if params[:q].present?
      query = params[:q].strip
      exact_pattern = "%#{query}%"

      words = query.split(/\s+/).reject(&:blank?)
      word_conditions = words.map { "title ILIKE ? OR original_title ILIKE ?" }.join(" OR ")
      word_params = words.flat_map { |w| ["%#{w}%", "%#{w}%"] }

      movies = movies.where(word_conditions, *word_params)

      # Prioritize exact phrase matches at the top of results
      quoted_exact = ActiveRecord::Base.connection.quote(exact_pattern)
      movies = movies.order(Arel.sql("
        CASE 
          WHEN title ILIKE #{quoted_exact} THEN 1
          WHEN original_title ILIKE #{quoted_exact} THEN 2
          ELSE 3
        END ASC
      "))
    end

    # 2. Filter by movie type (?type=movie | series)
    if params[:type].present?
      movie_type = params[:type] == "series" ? :series : :single_movie
      movies = movies.where(movie_type: movie_type)
    end

    # 3. Filter by genre (supports slug ?genre=action or ID ?genre_id=1)
    if params[:genre].present?
      movies = movies.joins(:genres).where(genres: { slug: params[:genre] })
    elsif params[:genre_id].present?
      movies = movies.joins(:genres).where(genres: { id: params[:genre_id] })
    end

    # 4. Filter by country (?country=US | CN | KR)
    if params[:country].present?
      movies = movies.where(country: params[:country])
    end

    # 5. Filter by release year (?year=2025)
    if params[:year].present?
      movies = movies.where(release_year: params[:year].to_i)
    end

    # 6. Filter by duration (matched with frontend dropdown options)
    case params[:duration]
    when "0-30", "<30"
      movies = movies.where("duration <= ?", 30)
    when "30-60"
      movies = movies.where(duration: 30..60)
    when "60-90"
      movies = movies.where(duration: 60..90)
    when "90-120"
      movies = movies.where(duration: 90..120)
    when "120-150"
      movies = movies.where(duration: 120..150)
    when "150-180"
      movies = movies.where(duration: 150..180)
    when "180+", ">180"
      movies = movies.where("duration >= ?", 180)
    end

    # 7. Sorting (?sort=publishDate | rating | viewCount)
    movies = case params[:sort]
             when "publishDate"
               movies.order(release_year: :desc, created_at: :desc)
             when "rating"
               movies.order(vote_average: :desc)
             when "viewCount"
               movies.order(vote_count: :desc)
             else
               params[:q].present? ? movies : movies.order(id: :desc)
             end

    # 8. Pagination: 30 movies per page
    page = (params[:page] || 1).to_i
    limit = (params[:limit] || 30).to_i
    total = movies.distinct.count
    total_pages = (total.to_f / limit).ceil

    movies = movies.distinct.offset((page - 1) * limit).limit(limit)

    # 9. Render JSON response
    render json: {
      total: total,
      total_pages: total_pages,
      page: page,
      limit: limit,
      data: movies.map { |movie| movie_summary(movie) }
    }, status: :ok
  end

  # GET /api/v1/movies/:id
  def show
    movie = Movie.find_by(id: params[:id]) || Movie.find_by(tmdb_id: params[:id])

    if movie
      render json: movie_detail(movie), status: :ok
    else
      render json: { error: "Movie not found" }, status: :not_found
    end
  end

  private

  # Summary data for movie listings (cards on homepage / search / browse)
  def movie_summary(movie)
    {
      id: movie.id,
      title: movie.title,
      original_title: movie.original_title,
      movie_type: movie.movie_type,
      release_year: movie.release_year,
      country: movie.country,
      duration: movie.duration,
      vote_average: movie.vote_average,
      poster_url: movie.poster_url,
      banner_url: movie.banner_url,
      genres: movie.genres.map { |g| { id: g.id, name: g.name, slug: g.slug } }
    }
  end

  # Full movie details for detail view
  def movie_detail(movie)
    movie_summary(movie).merge(
      overview: movie.overview,
      vote_count: movie.vote_count,
      age_rating: movie.age_rating,
      trailer_url: movie.trailer_url,
      video_url: movie.video_url
    )
  end
end
