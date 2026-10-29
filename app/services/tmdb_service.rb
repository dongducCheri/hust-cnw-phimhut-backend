class TmdbService 
  include HTTParty 
  base_uri "https://api.themoviedb.org/3"

  IMAGE_BASE_URL = "https://image.tmdb.org/t/p"

  def initialize 
    token = ENV["TMDB_READ_ACCESS_TOKEN"]
    raise "Chưa cấu hình TMDB_READ_ACCESS_TOKEN trong file .env" if token.blank? 

    @headers = {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json;charset=utf-8"
    }
  end
  
  def search_movies(query, page = 1)
    get("/search/movie", query: {
      query: query, 
      page: page, 
      language: "vi-VN" 
    })
  end

  def movie_details(tmdb_id)
    get("/movie/#{tmdb_id}", query: {
      language: "vi-VN",
      append_to_response: "credits,videos"
    })
  end

  def popular_movies(page = 1)
    get("/movie/popular", query: { page: page, language: "vi-VN" })
  end
 
  def self.image_url(path, size = "w500")
    return nil if path.blank?
    "#{IMAGE_BASE_URL}/#{size}#{path}"
  end

  private

  def get(path, options = {})
    options[:headers] = @headers
    response = self.class.get(path, options)
    response.success? ? response.parsed_response : nil
  end
end
