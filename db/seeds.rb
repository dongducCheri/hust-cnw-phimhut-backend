# --- SEED USERS ---
puts "1. Seeding users..."
admin = User.find_or_initialize_by(email: "admin@phimhut.com")
admin.update!(
  name: "Admin PhimHut",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  balance: 1_000_000,
  is_locked: false
)

user = User.find_or_initialize_by(email: "dongxuanduc2005@gmail.com")
user.update!(
  name: "Duc Dong",
  password: "54321cc",
  password_confirmation: "54321cc",
  role: :user,
  balance: 50_000,
  is_locked: false
)

# --- SEED GENRES ---
puts "2. Seeding genres..."
genres_data = [
  { name: "Hành động", tmdb_genre_id: 28 },
  { name: "Khoa học viễn tưởng", tmdb_genre_id: 878 },
  { name: "Kinh dị", tmdb_genre_id: 27 },
  { name: "Hoạt hình", tmdb_genre_id: 16 },
  { name: "Hài hước", tmdb_genre_id: 35 },
  { name: "Tâm lý", tmdb_genre_id: 18 }
]

genres = {}
genres_data.each do |g|
  genre = Genre.find_or_initialize_by(name: g[:name])
  genre.update!(tmdb_genre_id: g[:tmdb_genre_id])
  genres[g[:name]] = genre
end

# --- SEED MOVIES ---
puts "3. Seeding movies..."
movies_data = [
  {
    title: "Avengers: Hồi Kết",
    original_title: "Avengers: Endgame",
    tmdb_id: 299534,
    overview: "Sau những sự kiện tàn khốc của Infinity War, các siêu anh hùng còn sống sót tập hợp lại để đảo ngược hành động hủy diệt của Thanos.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "Mỹ",
    duration: 181,
    vote_average: 8.4,
    vote_count: 24500,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    is_published: true,
    genre_names: ["Hành động", "Khoa học viễn tưởng"]
  },
  {
    title: "Hố Đen Tử Thần",
    original_title: "Interstellar",
    tmdb_id: 157336,
    overview: "Một nhóm các nhà thám hiểm du hành qua một lỗ sâu vũ trụ trong nỗ lực đảm bảo sự sống còn của nhân loại.",
    movie_type: :single_movie,
    release_year: 2014,
    country: "Mỹ",
    duration: 169,
    vote_average: 8.7,
    vote_count: 34000,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/xJHokMbljvjADYdit5fK5VQsXEG.jpg",
    trailer_url: "https://www.youtube.com/watch?v=zSWdZVtXT7E",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    is_published: true,
    genre_names: ["Khoa học viễn tưởng", "Tâm lý"]
  },
  {
    title: "Vùng Đất Linh Hồn",
    original_title: "Spirited Away",
    tmdb_id: 129,
    overview: "Cô bé Chihiro 10 tuổi lạc vào thế giới của các linh hồn sau khi bố mẹ cô bị biến thành heo vì ăn vụng đồ ăn thần linh.",
    movie_type: :single_movie,
    release_year: 2001,
    country: "Nhật Bản",
    duration: 125,
    vote_average: 8.5,
    vote_count: 16000,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/mSDsSDwaP3E7dEfUPWy4J0djt4O.jpg",
    trailer_url: "https://www.youtube.com/watch?v=ByXuk9QqQkk",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    is_published: true,
    genre_names: ["Hoạt hình", "Tâm lý"]
  },
  {
    title: "Ký Sinh Trùng",
    original_title: "Parasite",
    tmdb_id: 496243,
    overview: "Tất cả thành viên trong một gia đình thất nghiệp dần xâm nhập vào cuộc sống của một gia đình giàu có bằng các thủ đoạn tinh vi.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "Hàn Quốc",
    duration: 132,
    vote_average: 8.5,
    vote_count: 17500,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/hiKmpZMGZsrkA3cdce8a7Dpos1j.jpg",
    trailer_url: "https://www.youtube.com/watch?v=5xH0RZE728M",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    is_published: true,
    genre_names: ["Tâm lý", "Hài hước"]
  },
  {
    title: "Dune: Hành Tinh Cát - Phần 2",
    original_title: "Dune: Part Two",
    tmdb_id: 693134,
    overview: "Paul Atreides hợp nhất với Chani và người Fremen để trả thù những kẻ đã hủy hoại gia đình mình, đồng thời ngăn chặn một tương lai đen tối.",
    movie_type: :single_movie,
    release_year: 2024,
    country: "Mỹ",
    duration: 166,
    vote_average: 8.6,
    vote_count: 5200,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/czembW0Rk1Ke7lCJGahAi8FjCOz.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/xOMo8BRK7PfcJv9JCnx7s5200bm.jpg",
    trailer_url: "https://www.youtube.com/watch?v=Way9Dexny3w",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    is_published: true,
    genre_names: ["Hành động", "Khoa học viễn tưởng"]
  }
]

movies_data.each do |data|
  genre_names = data.delete(:genre_names)
  movie = Movie.find_or_initialize_by(tmdb_id: data[:tmdb_id])
  movie.update!(data)

  # Gán thể loại cho phim thông qua bảng trung gian movie_genres
  selected_genres = genre_names.map { |name| genres[name] }.compact
  movie.genres = selected_genres
end

puts "Done! Seeded successfully:"
puts "- Users: #{User.count}"
puts "- Genres: #{Genre.count}"
puts "- Movies: #{Movie.count}"
puts "- MovieGenres: #{MovieGenre.count}"
