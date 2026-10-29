class Movie < ApplicationRecord
  validates :title, presence: true
  validates :tmdb_id, uniqueness: true, allow_nil: true
  validates :vote_average, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :vote_count, numericality: { greater_than_or_equal_to: 0 }

  enum :movie_type, { single_movie: 0, series: 1 }, default: :single_movie

  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres
  has_many :movie_credits, -> { order(order_index: :asc) }, dependent: :destroy
  has_many :people, through: :movie_credits
  has_many :episodes, -> { order(season_number: :asc, episode_number: :asc) }, dependent: :destroy
  has_many :watchlists, dependent: :destroy
end
