class Episode < ApplicationRecord
  belongs_to :movie

  validates :episode_number, presence: true, numericality: { greater_than: 0 }
  validates :season_number, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true

  has_one_attached :video 

  def stream_url
    return nil if object_key.blank?
    return object_key if object_key.start_with?("http://", "https://")

    "#{ENV.fetch('R2_PUBLIC_URL').chomp('/')}/#{object_key.sub(%r{\A/}, '')}"
  end
end
