class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :tmdb_genre_id, uniqueness: true, allow_nil: true
  validates :slug, uniqueness: true, allow_nil: true

  before_validation :generate_slug, on: :create

  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  private
  def generate_slug
    self.slug ||= name&.parameterize
  end
end
