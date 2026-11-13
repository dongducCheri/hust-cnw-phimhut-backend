class Genre < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  before_validation :generate_slug, on: :create

  validates :name, presence: true, uniqueness: true
  validates :tmdb_genre_id, uniqueness: true, allow_nil: true
  validates :slug, uniqueness: true, allow_nil: true
  
  private
  def generate_slug
    return if self.slug.present?
    return if self.name.blank?
    
    text = name.downcase
    text = text.gsub(/[đĐ]/, "d")
    text = text.gsub(/[àáạảãâầấậẩẫăằắặẳẵ]/, "a")
    text = text.gsub(/[èéẹẻẽêềếệểễ]/, "e")
    text = text.gsub(/[ìíịỉĩ]/, "i")
    text = text.gsub(/[òóọỏõôồốộổỗơờớợởỡ]/, "o")
    text = text.gsub(/[ùúụủũưừứựửữ]/, "u")
    text = text.gsub(/[ỳýỵỷỹ]/, "y")
    self.slug = text.parameterize
  end
end
