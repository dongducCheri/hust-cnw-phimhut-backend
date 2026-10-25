class Episode < ApplicationRecord
  belongs_to :movie

  validates :episode_number, presence: true, numericality: { greater_than: 0 }
  validates :season_number, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true
end
