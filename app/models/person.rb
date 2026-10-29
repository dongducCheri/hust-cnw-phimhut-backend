class Person < ApplicationRecord
  has_many :movie_credits, dependent: :destroy
  has_many :movies, through: :movie_credits

  validates :name, presence: true
  validates :tmdb_person_id, uniqueness: true, allow_nil: true
end
