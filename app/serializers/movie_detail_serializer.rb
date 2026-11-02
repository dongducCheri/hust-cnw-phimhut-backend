class MovieDetailSerializer < MovieSummarySerializer
  attributes :vote_count, :age_rating, :overview, :trailer_url, :video_url
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