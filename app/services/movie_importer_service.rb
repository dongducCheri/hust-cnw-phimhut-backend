class MovieImporterService
  def initialize
    @tmdb = TmdbService.new
  end

  def import_by_tmdb_id(tmdb_id)
    data = @tmdb.movie_details(tmdb_id)
    return { success: false, message: "Movie not found in TMDB" } unless data

    # 1. Tìm trailer YouTube
    trailer_key = data.dig("videos", "results")&.find { |v| v["site"] == "YouTube" && (v["type"] == "Trailer" || v["type"] == "Teaser") }&.dig("key")
    trailer_url = trailer_key ? "https://www.youtube.com/watch?v=#{trailer_key}" : nil

    # 2. Lưu hoặc cập nhật Movie
    movie = Movie.find_or_initialize_by(tmdb_id: data["id"])
    movie.update!(
      title: data["title"].presence || data["original_title"],
      original_title: data["original_title"],
      overview: data["overview"],
      movie_type: :single_movie,
      release_year: data["release_date"]&.split("-")&.first&.to_i,
      country: data.dig("origin_country", 0) || "US",
      duration: data["runtime"],
      vote_average: data["vote_average"]&.round(1) || 0.0,
      vote_count: data["vote_count"] || 0,
      poster_url: TmdbService.image_url(data["poster_path"], "w500"),
      banner_url: TmdbService.image_url(data["backdrop_path"], "original"),
      trailer_url: trailer_url,
      video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", # video mẫu
      is_published: true
    )

    # 3. Gắn thể loại Genres
    if data["genres"].present?
      genre_ids = data["genres"].map { |g| g["id"] }
      matched_genres = Genre.where(tmdb_genre_id: genre_ids)
      movie.genres = matched_genres if matched_genres.any?
    end

    # 4. Lưu diễn viên (Cast) & Đạo diễn (Crew)
    import_credits(movie, data["credits"]) if data["credits"]

    { success: true, movie: movie }
  end

  private

  def import_credits(movie, credits)
    # Lấy top 8 diễn viên nổi bật nhất
    cast_list = credits["cast"]&.first(8) || []
    cast_list.each_with_index do |cast_data, index|
      person = Person.find_or_initialize_by(tmdb_person_id: cast_data["id"])
      person.update!(
        name: cast_data["name"],
        profile_url: TmdbService.image_url(cast_data["profile_path"], "w200"),
        gender: cast_data["gender"]
      )

      credit = MovieCredit.find_or_initialize_by(
        movie: movie,
        person: person,
        credit_type: :cast
      )
      credit.update!(
        character_name: cast_data["character"],
        order_index: index
      )
    end

    # Lấy Đạo diễn (Director)
    directors = credits["crew"]&.select { |c| c["job"] == "Director" } || []
    directors.each do |director_data|
      person = Person.find_or_initialize_by(tmdb_person_id: director_data["id"])
      person.update!(
        name: director_data["name"],
        profile_url: TmdbService.image_url(director_data["profile_path"], "w200"),
        gender: director_data["gender"]
      )

      MovieCredit.find_or_create_by!(
        movie: movie,
        person: person,
        credit_type: :crew,
        job: "Đạo diễn"
      )
    end
  end
end
