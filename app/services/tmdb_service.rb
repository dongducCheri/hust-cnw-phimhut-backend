class TmdbService 
  include HTTParty
  #Gốc đường dẫn chung tất cả dịch vụ trên TMDb
  base_uri "https://api.themoviedb.org/3"

  IMAGE_BASE_URL = "https://image.tmdb.org/t/p"

  def initialize 
    token = ENV["TMDB_READ_ACCESS_TOKEN"]

    @headers = {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json;charset=utf-8"
    }
  end
  
  def search_movies(query, page = 1)
    #Tìm kiếm phim theo từ khóa query 
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
      #trả về thêm /movie/#{id}/credits, movie/#{id}/videos 
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
    # path: vd: /movie/popular, /movie/77606, /search/movie 
    # sau khi ghép path với base_uri : https://api.themoviedb.org/3/search/movie
    # option là một hash -> HTTParty biến thành query_params trên URL 
    # option: options = { query: { page: 1, language: "vi-VN" } }, sau đó có cả thêm @headers 
    # URL: https://api.themoviedb.org/3/movie/popular?page=1&language=vi-VN
    response.success? ? response.parsed_response : nil
  end
end
