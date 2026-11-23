class MoviesQuery
  def initialize(params)
    @params = params
  end

  def call 
    movies = Movie.where(is_published: true)
    movies = search(movies)
    movies = filter_by_type(movies)
    movies = filter_by_genre(movies)
    movies = filter_by_country(movies)
    movies = filter_by_year(movies)
    movies = filter_by_duration(movies)
    movies = sort(movies)
    movies 
  end

  private
  # ?q=avengers
  def search(movies)
    if @params[:q].present?
      keyword = "%#{@params[:q].strip}%"
      movies = movies.where("title ILIKE ? OR original_title ILIKE ?", keyword, keyword)
    end
    movies
  end

  # ?type=movie / ?type=series
  def filter_by_type(movies)
    if @params[:type] == "series"
      movies = movies.where(movie_type: :series)
    elsif @params[:type] == "movie"
      movies = movies.where(movie_type: :single_movie)
    end
    movies
  end

  # ?genre=hanh-dong
  def filter_by_genre(movies)
    if @params[:genre].present?
      movies = movies.joins(:genres).where(genres: { slug: @params[:genre] })
    end
    movies
  end

  # ?country=US
  def filter_by_country(movies)
    if @params[:country].present?
      movies = movies.where(country: @params[:country])
    end
    movies
  end

  # ?year=2024
  def filter_by_year(movies)
    if @params[:year].present?
      movies = movies.where(release_year: @params[:year])
    end
    movies
  end

  # ?duration=90-120
  def filter_by_duration(movies)
    case @params[:duration]
    when "0-30"    then movies.where(duration: 0..30)
    when "30-60"   then movies.where(duration: 30..60)
    when "60-90"   then movies.where(duration: 60..90)
    when "90-120"  then movies.where(duration: 90..120)
    when "120-150" then movies.where(duration: 120..150)
    when "150-180" then movies.where(duration: 150..180)
    when "180+"    then movies.where("duration >= ?", 180)
    else movies
    end
  end

  # ?sort=publishDate | rating | viewCount
  def sort(movies)
    case @params[:sort]
    when "publishDate"  then movies.order(release_year: :desc)
    when "rating"       then movies.order(vote_average: :desc)
    when "viewCount"    then movies.order(vote_count: :desc)
    else movies.order(id: :desc)
    end
  end
end