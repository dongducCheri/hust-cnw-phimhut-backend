class MovieSummarySerializer
  include Alba::Resource

  attributes :id, :title, :original_title, :movie_type, :release_year, 
  :country, :duration, :vote_average, :poster_url, :banner_url

  many :genres, resource: GenreSerializer
end