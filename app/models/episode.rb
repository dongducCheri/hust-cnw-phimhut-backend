class Episode < ApplicationRecord
  belongs_to :movie

  validates :episode_number, presence: true, numericality: { greater_than: 0 }
  validates :season_number, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true

  has_one_attached :video 

  def stream_url 
    return nil if video_url.blank?
    "#{ENV.fetch('R2_PUBLIC_URL')}/#{video_url}"
  end
end
