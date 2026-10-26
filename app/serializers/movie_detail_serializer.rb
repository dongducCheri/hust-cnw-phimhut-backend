class MovieDetailSerializer
  include Alba::Resource

  attributes :id, :title, :original_title, :movie_type, :release_year,
  :country, :duration, :vote_average, :vote_count, :age_rating,
  :poster_url, :banner_url, :overview, :trailer_url, :video_url

  many :genres, resource: GenreSerializer
  many :episodes, resource: EpisodeSerializer

  attribute :creators do |movie|
    movie.movie_credits.select(&:crew?).map do |c|
      { person_id: c.person_id, name: c.person.name, job: c.job }
    end
  end

  attribute :casts do |movie|
    movie.movie_credits.select(&:cast?).map do |c|
      {
        person_id: c.person_id,
        name: c.person.name,
        character_name: c.character_name,
        profile_url: c.person.profile_url,
        order_index: c.order_index
      }
    end
  end
end