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
  { name: "Hành động", slug: "hanh-dong", tmdb_genre_id: 28 },
  { name: "Phiêu lưu", slug: "phieu-luu", tmdb_genre_id: 12 },
  { name: "Hoạt hình", slug: "hoat-hinh", tmdb_genre_id: 16 },
  { name: "Hài hước", slug: "hai-huoc", tmdb_genre_id: 35 },
  { name: "Tội phạm", slug: "toi-pham", tmdb_genre_id: 80 },
  { name: "Tài liệu", slug: "tai-lieu", tmdb_genre_id: 99 },
  { name: "Tâm lý", slug: "tam-ly", tmdb_genre_id: 18 },
  { name: "Gia đình", slug: "gia-dinh", tmdb_genre_id: 10751 },
  { name: "Kinh dị", slug: "kinh-di", tmdb_genre_id: 27 },
  { name: "Bí ẩn", slug: "bi-an", tmdb_genre_id: 9648 },
  { name: "Lãng mạn", slug: "lang-man", tmdb_genre_id: 10749 },
  { name: "Khoa học viễn tưởng", slug: "khoa-hoc-vien-tuong", tmdb_genre_id: 878 },
  { name: "Chiến tranh", slug: "chien-tranh", tmdb_genre_id: 10752 },
  { name: "Giật gân", slug: "giat-gan", tmdb_genre_id: 53 },
  { name: "Võ thuật", slug: "vo-thuat", tmdb_genre_id: 10001 },
  { name: "Cổ trang", slug: "co-trang", tmdb_genre_id: 10002 }
]

genres = {}
genres_data.each do |g|
  genre = Genre.find_or_initialize_by(name: g[:name])
  genre.update!(slug: g[:slug], tmdb_genre_id: g[:tmdb_genre_id])
  genres[g[:name]] = genre
end

# --- SEED 50 REALISTIC MOVIES ---
puts "3. Seeding 50 movies..."
movies_data = [
  # 1-10
  {
    title: "Avengers: Hồi Kết",
    original_title: "Avengers: Endgame",
    tmdb_id: 299534,
    overview: "Sau sự kiện tàn khốc của Infinity War, các siêu anh hùng còn sống sót tìm cách đảo ngược hành động của Thanos.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "US",
    duration: 181,
    vote_average: 8.4,
    vote_count: 24500,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Hành động", "Khoa học viễn tưởng", "Phiêu lưu"]
  },
  {
    title: "Hố Đen Tử Thần",
    original_title: "Interstellar",
    tmdb_id: 157336,
    overview: "Nhóm nhà thám hiểm vượt qua hố sâu vũ trụ nhằm tìm kiếm hành tinh mới có thể duy trì sự sống cho nhân loại.",
    movie_type: :single_movie,
    release_year: 2014,
    country: "US",
    duration: 169,
    vote_average: 8.7,
    vote_count: 34000,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/xJHokMbljvjADYdit5fK5VQsXEG.jpg",
    trailer_url: "https://www.youtube.com/watch?v=zSWdZVtXT7E",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Khoa học viễn tưởng", "Tâm lý", "Phiêu lưu"]
  },
  {
    title: "Vùng Đất Linh Hồn",
    original_title: "Spirited Away",
    tmdb_id: 129,
    overview: "Cô bé Chihiro 10 tuổi lạc vào thế giới của thần linh và phải tìm cách giải cứu bố mẹ bị biến thành heo.",
    movie_type: :single_movie,
    release_year: 2001,
    country: "JP",
    duration: 125,
    vote_average: 8.5,
    vote_count: 16000,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/mSDsSDwaP3E7dEfUPWy4J0djt4O.jpg",
    trailer_url: "https://www.youtube.com/watch?v=ByXuk9QqQkk",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Hoạt hình", "Gia đình", "Tâm lý"]
  },
  {
    title: "Ký Sinh Trùng",
    original_title: "Parasite",
    tmdb_id: 496243,
    overview: "Các thành viên trong một gia đình nghèo từng bước thâm nhập vào gia đình thượng lưu bằng các mánh khóe tinh vi.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "KR",
    duration: 132,
    vote_average: 8.5,
    vote_count: 17500,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/hiKmpZMGZsrkA3cdce8a7Dpos1j.jpg",
    trailer_url: "https://www.youtube.com/watch?v=5xH0RZE728M",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Tâm lý", "Hài hước", "Giật gân"]
  },
  {
    title: "Dune: Hành Tinh Cát - Phần 2",
    original_title: "Dune: Part Two",
    tmdb_id: 693134,
    overview: "Paul Atreides đồng hành cùng người Fremen đứng lên chống lại những kẻ đã hủy diệt gia tộc mình.",
    movie_type: :single_movie,
    release_year: 2024,
    country: "US",
    duration: 166,
    vote_average: 8.6,
    vote_count: 5200,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/czembW0Rk1Ke7lCJGahAi8FjCOz.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/xOMo8BRK7PfcJv9JCnx7s5200bm.jpg",
    trailer_url: "https://www.youtube.com/watch?v=Way9Dexny3w",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Hành động", "Khoa học viễn tưởng", "Phiêu lưu"]
  },
  {
    title: "Oppenheimer",
    original_title: "Oppenheimer",
    tmdb_id: 872585,
    overview: "Câu chuyện lịch sử về nhà vật lý lý thuyết J. Robert Oppenheimer và dự án Manhattan chế tạo bom nguyên tử.",
    movie_type: :single_movie,
    release_year: 2023,
    country: "US",
    duration: 180,
    vote_average: 8.1,
    vote_count: 8900,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/rLb2cwF3Pazuxaj0sRXQ037tGI1.jpg",
    trailer_url: "https://www.youtube.com/watch?v=uYPbbksJxIg",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Tâm lý", "Lịch sử"]
  },
  {
    title: "Trò Chơi Con Mực",
    original_title: "Squid Game",
    tmdb_id: 93405,
    overview: "Hàng trăm người chơi nợ nần chấp nhận tham gia trò chơi sinh tồn với giải thưởng khổng lồ nhưng giá phải trả là tính mạng.",
    movie_type: :series,
    release_year: 2021,
    country: "KR",
    duration: 60,
    vote_average: 7.8,
    vote_count: 13500,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/dDlG1v7zEaT96y2J0W1W1N6N18a.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/oaGvjB0DvdurWhf96Twu7h9OPUQ.jpg",
    trailer_url: "https://www.youtube.com/watch?v=oqxAJKy0ii4",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Hành động", "Tâm lý", "Bí ẩn"]
  },
  {
    title: "Chiến Binh Báo Đen",
    original_title: "Black Panther",
    tmdb_id: 284054,
    overview: "T'Challa trở về quê nhà Wakanda để kế vị ngai vàng và bảo vệ công nghệ của đất nước khỏi kẻ thù.",
    movie_type: :single_movie,
    release_year: 2018,
    country: "US",
    duration: 134,
    vote_average: 7.4,
    vote_count: 21000,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/uxzzxijgPIY7slzFvMotPv8vlum.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b6ZJZHUytAnAOK4NjXg175i23Qc.jpg",
    trailer_url: "https://www.youtube.com/watch?v=xjDjIWPwcPU",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
    genre_names: ["Hành động", "Khoa học viễn tưởng", "Phiêu lưu"]
  },
  {
    title: "Tên Bạn Là Gì?",
    original_title: "Your Name.",
    tmdb_id: 372058,
    overview: "Hai thiếu niên xa lạ bỗng nhiên phát hiện họ hoán đổi thân xác cho nhau qua những giấc mơ kỳ lạ.",
    movie_type: :single_movie,
    release_year: 2016,
    country: "JP",
    duration: 106,
    vote_average: 8.5,
    vote_count: 11000,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/q719jXXEzOoYaps6qFsCLLkWwfP.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/dIWwZW7dJJtqYvi5MDmfgx9TCq1.jpg",
    trailer_url: "https://www.youtube.com/watch?v=xU47nhruN-Q",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Hoạt hình", "Lãng mạn", "Tâm lý"]
  },
  {
    title: "Thực Đơn Tình Yêu",
    original_title: "Love on the Menu",
    tmdb_id: 574211,
    overview: "Một giám đốc điều hành thực phẩm hợp tác với một đầu bếp tài ba để giải cứu nhà hàng và tìm thấy tình yêu đích thực.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "US",
    duration: 84,
    vote_average: 6.9,
    vote_count: 120,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/nJ5fR9M9E0M0jLpYvBv9u2H9M9M.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/9y0p5h0x7r0o4e8w1q1p9e0r1t.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Lãng mạn", "Hài hước"]
  },

  # 11-20
  {
    title: "Tình Yêu Điên Cuồng",
    original_title: "Crazy Love",
    tmdb_id: 157080,
    overview: "Một mối tình lãng mạn ngọt ngào nhưng cũng đầy hỗn loạn và hài hước giữa một giảng viên toán học thiên tài và cô thư ký.",
    movie_type: :series,
    release_year: 2022,
    country: "KR",
    duration: 65,
    vote_average: 7.7,
    vote_count: 450,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/y4aA7W9e4e6y1p9e0r1t.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Lãng mạn", "Hài hước", "Tâm lý"]
  },
  {
    title: "Diệp Vấn",
    original_title: "Ip Man",
    tmdb_id: 14756,
    overview: "Huyền thoại Vịnh Xuân Quyền Diệp Vấn đứng lên bảo vệ danh dự dân tộc trước quân xâm lược trong thời kỳ kháng chiến.",
    movie_type: :single_movie,
    release_year: 2008,
    country: "CN",
    duration: 106,
    vote_average: 8.0,
    vote_count: 3600,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/fP1e6w6e0a8w1q1p9e0r1t.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/9r9e0a8w1q1p9e0r1t.jpg",
    trailer_url: "https://www.youtube.com/watch?v=1AJxXQ7xojE",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Võ thuật", "Hành động", "Lịch sử"]
  },
  {
    title: "Đột Phá Vòng Vây",
    original_title: "Blood Forged Breakout",
    tmdb_id: 1029381,
    overview: "Các chiến sĩ quả cảm phá tan vòng vây của kẻ thù trong một trận chiến ác liệt giữa thời kỳ bom đạn.",
    movie_type: :single_movie,
    release_year: 2025,
    country: "CN",
    duration: 95,
    vote_average: 7.1,
    vote_count: 300,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/8c7e0a8w1q1p9e0r1t.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/7c7e0a8w1q1p9e0r1t.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Chiến tranh", "Hành động"]
  },
  {
    title: "Trừ Phỉ",
    original_title: "Beat the Tiger",
    tmdb_id: 1029382,
    overview: "Cuộc chiến truy quét các băng nhóm thảo khấu nguy hiểm ẩn náu tại vùng rừng núi hiểm trở tuyết trắng.",
    movie_type: :single_movie,
    release_year: 2025,
    country: "CN",
    duration: 102,
    vote_average: 6.8,
    vote_count: 210,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/6c7e0a8w1q1p9e0r1t.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/5c7e0a8w1q1p9e0r1t.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Hành động", "Tội phạm"]
  },
  {
    title: "Hạ Cánh Nơi Anh",
    original_title: "Crash Landing on You",
    tmdb_id: 94796,
    overview: "Nữ thừa kế tài phiệt Hàn Quốc gặp nạn khi dù lượn và vô tình rơi vào khu vực biên giới Bắc Triều Tiên, gặp gỡ một sĩ quan quân đội.",
    movie_type: :series,
    release_year: 2019,
    country: "KR",
    duration: 80,
    vote_average: 8.8,
    vote_count: 850,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/q23q7e0a8w1q1p9e0r1t.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/p23q7e0a8w1q1p9e0r1t.jpg",
    trailer_url: "https://www.youtube.com/watch?v=GVQGWgeVc4k",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Lãng mạn", "Hài hước", "Tâm lý"]
  },
  {
    title: "Mai",
    original_title: "Mai",
    tmdb_id: 1226578,
    overview: "Mai, một phụ nữ làm nghề massage gần 40 tuổi mang nhiều tổn thương quá khứ, vướng vào chuyện tình với chàng trai trẻ Dương.",
    movie_type: :single_movie,
    release_year: 2024,
    country: "VN",
    duration: 131,
    vote_average: 7.2,
    vote_count: 1500,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/r126578.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b1226578.jpg",
    trailer_url: "https://www.youtube.com/watch?v=0kF419N7c3w",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Tâm lý", "Lãng mạn", "Hài hước"]
  },
  {
    title: "Nhà Bà Nữ",
    original_title: "The House of No Man",
    tmdb_id: 1069176,
    overview: "Mâu thuẫn thế hệ và tình yêu trong một gia đình ba thế hệ bán bánh canh cua do người phụ nữ độc tài làm chủ.",
    movie_type: :single_movie,
    release_year: 2023,
    country: "VN",
    duration: 102,
    vote_average: 6.9,
    vote_count: 980,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/r1069176.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b1069176.jpg",
    trailer_url: "https://www.youtube.com/watch?v=0bT496d8k9s",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Gia đình", "Hài hước", "Tâm lý"]
  },
  {
    title: "Bố Già",
    original_title: "The Godfather",
    tmdb_id: 238,
    overview: "Bi kịch gia đình mafia Corleone khi quyền lực chuyển giao từ ông trùm Vito sang người con trai út Michael.",
    movie_type: :single_movie,
    release_year: 1972,
    country: "US",
    duration: 175,
    vote_average: 8.7,
    vote_count: 20000,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/tmU7aGHgstxy7FAaC2wL4xI8j99.jpg",
    trailer_url: "https://www.youtube.com/watch?v=sY1S349gOn0",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Tội phạm", "Tâm lý"]
  },
  {
    title: "Kỵ Sĩ Bóng Đêm",
    original_title: "The Dark Knight",
    tmdb_id: 155,
    overview: "Người Dơi đối đầu với Joker - kẻ tâm thần gieo rắc hỗn loạn kinh hoàng tại thành phố Gotham.",
    movie_type: :single_movie,
    release_year: 2008,
    country: "US",
    duration: 152,
    vote_average: 8.5,
    vote_count: 32000,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg",
    trailer_url: "https://www.youtube.com/watch?v=EXeTwQWrcwY",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Hành động", "Tội phạm", "Tâm lý"]
  },
  {
    title: "Chúa Tể Những Chiếc Nhẫn: Sự Trở Về Của Nhà Vua",
    original_title: "The Lord of the Rings: The Return of the King",
    tmdb_id: 122,
    overview: "Trận chiến quyết định vận mệnh của Trung Địa và chuyến hành trình hủy diệt Chiếc Nhẫn Chúa tại Núi Diệt Vong.",
    movie_type: :single_movie,
    release_year: 2003,
    country: "US",
    duration: 201,
    vote_average: 8.6,
    vote_count: 24000,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/2u7zbn8EudG6kLlBzUYqP8RyFU4.jpg",
    trailer_url: "https://www.youtube.com/watch?v=r5X-hFf6Bwo",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Phiêu lưu", "Hành động"]
  },

  # 21-30
  {
    title: "Avatar: Dòng Chảy Của Nước",
    original_title: "Avatar: The Way of Water",
    tmdb_id: 76600,
    overview: "Jake Sully cùng Neytiri và các con tìm kiếm nơi trú ẩn tại bộ tộc đại dương Metkayina khi loài người trở lại Pandora.",
    movie_type: :single_movie,
    release_year: 2022,
    country: "US",
    duration: 192,
    vote_average: 7.7,
    vote_count: 11000,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg",
    trailer_url: "https://www.youtube.com/watch?v=d9MyW72ELq0",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Khoa học viễn tưởng", "Phiêu lưu", "Hành động"]
  },
  {
    title: "John Wick: Phần 4",
    original_title: "John Wick: Chapter 4",
    tmdb_id: 603692,
    overview: "John Wick tìm cách đánh bại Hội Đồng Tối Cao để giành lại tự do với những màn đấu súng và võ thuật nghẹt thở toàn cầu.",
    movie_type: :single_movie,
    release_year: 2023,
    country: "US",
    duration: 169,
    vote_average: 7.8,
    vote_count: 6100,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/vZloFAK7NKnMGKEslUsZevaRAVm.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/h8gHn0OzRoglpqwtY4Ge9gu0qn8.jpg",
    trailer_url: "https://www.youtube.com/watch?v=qEVUtrk8_B4",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Hành động", "Giật gân", "Tội phạm"]
  },
  {
    title: "Thám Tử Lừng Danh Conan: Tàu Ngầm Sắt Màu Đen",
    original_title: "Detective Conan: Black Iron Submarine",
    tmdb_id: 1047041,
    overview: "Conan và tổ chức Áo Đen đụng độ nảy lửa tại cơ sở kết nối camera an ninh toàn cầu dưới đáy biển Hachijo.",
    movie_type: :single_movie,
    release_year: 2023,
    country: "JP",
    duration: 109,
    vote_average: 7.5,
    vote_count: 220,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/ksBQ4Zf5P3e56E2a8w1q1p9e0r1.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/jsBQ4Zf5P3e56E2a8w1q1p9e0r1.jpg",
    trailer_url: "https://www.youtube.com/watch?v=xV3k7zLp7kE",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Hoạt hình", "Bí ẩn", "Hành động"]
  },
  {
    title: "Thanh Gươm Diệt Quỷ: Chuyến Tàu Vô Tận",
    original_title: "Demon Slayer: Mugen Train",
    tmdb_id: 635302,
    overview: "Tanjiro và Viêm Trụ Rengoku chiến đấu với quỷ Thượng Huyền trên chuyến tàu vô tận bí ẩn.",
    movie_type: :single_movie,
    release_year: 2020,
    country: "JP",
    duration: 117,
    vote_average: 8.3,
    vote_count: 3700,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/h8duW2HnB58p0f5P3e56E2a8w1q.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/m8duW2HnB58p0f5P3e56E2a8w1q.jpg",
    trailer_url: "https://www.youtube.com/watch?v=bFwdl2PPAR8",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Hoạt hình", "Hành động", "Võ thuật"]
  },
  {
    title: "Trường Học Âm Nhạc",
    original_title: "School of Rock",
    tmdb_id: 1584,
    overview: "Một nghệ sĩ guitar thất nghiệp mạo danh giáo viên dạy thay và bí mật thành lập ban nhạc rock cùng các học sinh tiểu học.",
    movie_type: :single_movie,
    release_year: 2003,
    country: "US",
    duration: 109,
    vote_average: 7.1,
    vote_count: 5500,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/z1584z.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b1584z.jpg",
    trailer_url: "https://www.youtube.com/watch?v=3PsUJFEBC74",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Hài hước", "Gia đình"]
  },
  {
    title: "Quỷ Ám: Tín Đồ",
    original_title: "The Exorcist: Believer",
    tmdb_id: 807172,
    overview: "Khi hai cô bé mất tích trong rừng rồi trở về với những biểu hiện ma quỷ kinh hoàng, các bậc cha mẹ phải tìm đến người từng trải.",
    movie_type: :single_movie,
    release_year: 2023,
    country: "US",
    duration: 111,
    vote_average: 6.1,
    vote_count: 980,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/q807172.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/p807172.jpg",
    trailer_url: "https://www.youtube.com/watch?v=PIxpPMyGZDU",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Kinh dị", "Bí ẩn"]
  },
  {
    title: "Ám Ảnh Kinh Hoàng",
    original_title: "The Conjuring",
    tmdb_id: 138843,
    overview: "Hai nhà điều tra hiện tượng siêu nhiên Ed và Lorraine Warren đến trợ giúp một gia đình bị đe dọa bởi thế lực hắc ám tại trang trại.",
    movie_type: :single_movie,
    release_year: 2013,
    country: "US",
    duration: 112,
    vote_average: 7.5,
    vote_count: 11000,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w138843.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b138843.jpg",
    trailer_url: "https://www.youtube.com/watch?v=k10ETZ41q5o",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Kinh dị", "Giật gân"]
  },
  {
    title: "Truy Tìm Kẻ Sát Nhân",
    original_title: "Memories of Murder",
    tmdb_id: 11423,
    overview: "Tại một vùng quê Hàn Quốc năm 1986, hai viên cảnh sát với tính cách trái ngược cùng điều tra vụ án giết người hàng loạt chấn động.",
    movie_type: :single_movie,
    release_year: 2003,
    country: "KR",
    duration: 132,
    vote_average: 8.1,
    vote_count: 3600,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w11423.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b11423.jpg",
    trailer_url: "https://www.youtube.com/watch?v=0n_HbBQpwhE",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Tội phạm", "Bí ẩn", "Giật gân"]
  },
  {
    title: "Chuyến Tàu Sinh Tử",
    original_title: "Train to Busan",
    tmdb_id: 396535,
    overview: "Đại dịch thây ma bất ngờ bùng phát khi một người cha và con gái đang trên chuyến tàu cao tốc từ Seoul đến Busan.",
    movie_type: :single_movie,
    release_year: 2016,
    country: "KR",
    duration: 118,
    vote_average: 7.7,
    vote_count: 5200,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w396535.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b396535.jpg",
    trailer_url: "https://www.youtube.com/watch?v=pyWuHv2-Abk",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Kinh dị", "Hành động", "Giật gân"]
  },
  {
    title: "Thế Thân",
    original_title: "Avatar",
    tmdb_id: 19995,
    overview: "Một cựu lính thủy đánh bộ tàn tật được gửi đến mặt trăng Pandora và nảy sinh tình cảm với nàng công chúa Na'vi.",
    movie_type: :single_movie,
    release_year: 2009,
    country: "US",
    duration: 162,
    vote_average: 7.6,
    vote_count: 31000,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/6EiRUJpuoeQPghrs3YNktfnqOVh.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/vL5LR6WdxWPjC1dcb143Qf5zDcf.jpg",
    trailer_url: "https://www.youtube.com/watch?v=5PSNL1qE6VY",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Khoa học viễn tưởng", "Phiêu lưu", "Hành động"]
  },

  # 31-40
  {
    title: "Đấu La Đại Lục",
    original_title: "Soul Land",
    tmdb_id: 85937,
    overview: "Đường Tam tái sinh vào thế giới Đấu La Đại Lục, đánh thức song sinh võ hồn và bắt đầu hành trình trở thành thần.",
    movie_type: :series,
    release_year: 2018,
    country: "CN",
    duration: 25,
    vote_average: 8.2,
    vote_count: 340,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/w85937.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b85937.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Hoạt hình", "Võ thuật", "Phiêu lưu"]
  },
  {
    title: "Tinh Hán Xán Lạn",
    original_title: "Love Like the Galaxy",
    tmdb_id: 205322,
    overview: "Mối lương duyên trắc trở nhưng sâu sắc giữa chàng tướng quân lạnh lùng Lăng Bất Nghi và nàng Trình Thiếu Thương bướng bỉnh.",
    movie_type: :series,
    release_year: 2022,
    country: "CN",
    duration: 45,
    vote_average: 8.3,
    vote_count: 280,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/w205322.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b205322.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Cổ trang", "Lãng mạn", "Tâm lý"]
  },
  {
    title: "Trường Nguyệt Tẫn Minh",
    original_title: "Till the End of the Moon",
    tmdb_id: 213713,
    overview: "Để cứu lấy tam giới, Lê Tô Tô du hành ngược thời gian 500 năm trước để ngăn chặn ma thần Đạm Đài Tẫn thức tỉnh.",
    movie_type: :series,
    release_year: 2023,
    country: "CN",
    duration: 50,
    vote_average: 8.1,
    vote_count: 310,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/w213713.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b213713.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Cổ trang", "Lãng mạn", "Võ thuật"]
  },
  {
    title: "Gia Tộc Quý Tộc",
    original_title: "Succession",
    tmdb_id: 76331,
    overview: "Cuộc chiến vương quyền tàn nhẫn giữa bốn người con khi người cha già - ông trùm truyền thông toàn cầu - chuẩn bị thoái vị.",
    movie_type: :series,
    release_year: 2018,
    country: "US",
    duration: 65,
    vote_average: 8.6,
    vote_count: 1900,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w76331.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b76331.jpg",
    trailer_url: "https://www.youtube.com/watch?v=OzY2r87Fpg8",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Tâm lý"]
  },
  {
    title: "Vinh Quang Trong Thù Hận",
    original_title: "The Glory",
    tmdb_id: 136283,
    overview: "Sau nhiều năm chịu đựng bạo lực học đường tàn khốc, người phụ nữ bắt đầu kế hoạch trả thù tinh vi từng kẻ bắt nạt mình.",
    movie_type: :series,
    release_year: 2022,
    country: "KR",
    duration: 55,
    vote_average: 8.6,
    vote_count: 780,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w136283.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b136283.jpg",
    trailer_url: "https://www.youtube.com/watch?v=tqFFKDbfn-s",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Tâm lý", "Giật gân"]
  },
  {
    title: "Băng Đảng Peaky Blinders",
    original_title: "Peaky Blinders",
    tmdb_id: 60574,
    overview: "Gia đình gangster Shelby gốc Gypsy vươn lên kiểm soát thành phố Birmingham nước Anh những năm sau Thế chiến thứ nhất.",
    movie_type: :series,
    release_year: 2013,
    country: "UK",
    duration: 60,
    vote_average: 8.5,
    vote_count: 9500,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w60574.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b60574.jpg",
    trailer_url: "https://www.youtube.com/watch?v=oVzVdvGIC7U",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Tội phạm", "Tâm lý", "Lịch sử"]
  },
  {
    title: "Cậu Bé Mất Tích",
    original_title: "Stranger Things",
    tmdb_id: 66732,
    overview: "Một cậu bé mất tích tại thị trấn nhỏ Hawkins, kéo theo sự xuất hiện của cô bé có siêu năng lực và thế giới Upside Down đảo ngược.",
    movie_type: :series,
    release_year: 2016,
    country: "US",
    duration: 55,
    vote_average: 8.6,
    vote_count: 17000,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/w66732.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b66732.jpg",
    trailer_url: "https://www.youtube.com/watch?v=b9EkMc79ZSU",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Khoa học viễn tưởng", "Bí ẩn", "Tâm lý"]
  },
  {
    title: "Giải Cứu Binh Nhì Ryan",
    original_title: "Saving Private Ryan",
    tmdb_id: 857,
    overview: "Sau trận đổ bộ Normandy đẫm máu, một toán lính Mỹ được lệnh tiến sâu vào vùng địch chiếm đóng để tìm cứu một người lính duy nhất.",
    movie_type: :single_movie,
    release_year: 1998,
    country: "US",
    duration: 169,
    vote_average: 8.2,
    vote_count: 15500,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w857.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b857.jpg",
    trailer_url: "https://www.youtube.com/watch?v=zwhP5b4tD6g",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Chiến tranh", "Lịch sử", "Hành động"]
  },
  {
    title: "Trận Đánh Trân Châu Cảng",
    original_title: "Pearl Harbor",
    tmdb_id: 1535,
    overview: "Câu chuyện tình tay ba đầy ngang trái giữa bom đạn trong cuộc tấn công bất ngờ của hải quân Nhật vào Trân Châu Cảng.",
    movie_type: :single_movie,
    release_year: 2001,
    country: "US",
    duration: 183,
    vote_average: 6.9,
    vote_count: 6200,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/w1535.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b1535.jpg",
    trailer_url: "https://www.youtube.com/watch?v=cZoz18r_f74",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Chiến tranh", "Lãng mạn", "Lịch sử"]
  },
  {
    title: "1917",
    original_title: "1917",
    tmdb_id: 530915,
    overview: "Hai người lính trẻ người Anh được giao nhiệm vụ băng qua lãnh thổ địch trong Thế chiến I để truyền thông điệp khẩn cấp.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "UK",
    duration: 119,
    vote_average: 7.9,
    vote_count: 12000,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/w530915.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b530915.jpg",
    trailer_url: "https://www.youtube.com/watch?v=YqNYrYUiMfg",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Chiến tranh", "Lịch sử", "Hành động"]
  },

  # 41-50
  {
    title: "Hành Tinh Khỉ: Vương Quốc Mới",
    original_title: "Kingdom of the Planet of the Apes",
    tmdb_id: 653346,
    overview: "Nhiều thế hệ sau triều đại của Caesar, một chú khỉ trẻ bắt đầu chuyến hành trình định hình tương lai cho cả loài khỉ và con người.",
    movie_type: :single_movie,
    release_year: 2024,
    country: "US",
    duration: 145,
    vote_average: 7.2,
    vote_count: 2400,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/w653346.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b653346.jpg",
    trailer_url: "https://www.youtube.com/watch?v=Kdr5oedn7q8",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Khoa học viễn tưởng", "Phiêu lưu", "Hành động"]
  },
  {
    title: "Hành Tinh Cát - Phần 1",
    original_title: "Dune: Part One",
    tmdb_id: 438631,
    overview: "Paul Atreides phải tới hành tinh nguy hiểm nhất vũ trụ Arrakis để bảo vệ tương lai gia tộc và thần dân.",
    movie_type: :single_movie,
    release_year: 2021,
    country: "US",
    duration: 155,
    vote_average: 7.8,
    vote_count: 10500,
    age_rating: "C13",
    poster_url: "https://image.tmdb.org/t/p/w500/w438631.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b438631.jpg",
    trailer_url: "https://www.youtube.com/watch?v=n9xhJrPXop4",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Khoa học viễn tưởng", "Phiêu lưu"]
  },
  {
    title: "Nhện Nhí: Du Hành Vũ Trụ Nhện",
    original_title: "Spider-Man: Across the Spider-Verse",
    tmdb_id: 569094,
    overview: "Miles Morales chu du qua đa vũ trụ nhện và phải đưa ra quyết định khó khăn để cứu lấy người thân yêu nhất.",
    movie_type: :single_movie,
    release_year: 2023,
    country: "US",
    duration: 140,
    vote_average: 8.4,
    vote_count: 6700,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/w569094.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b569094.jpg",
    trailer_url: "https://www.youtube.com/watch?v=cqGjhVJWtEg",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Hoạt hình", "Hành động", "Khoa học viễn tưởng"]
  },
  {
    title: "Kung Fu Panda 4",
    original_title: "Kung Fu Panda 4",
    tmdb_id: 1011985,
    overview: "Po phải tìm kiếm và huấn luyện một Thần Long Đại Hiệp mới trước khi thăng cấp làm Thủ lĩnh Tinh thần của Thung lũng Hòa Bình.",
    movie_type: :single_movie,
    release_year: 2024,
    country: "US",
    duration: 94,
    vote_average: 7.1,
    vote_count: 2300,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/w1011985.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b1011985.jpg",
    trailer_url: "https://www.youtube.com/watch?v=_inKs4eeHiI",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    genre_names: ["Hoạt hình", "Hài hước", "Võ thuật", "Gia đình"]
  },
  {
    title: "Bao Giờ Cho Đến Tháng Mười",
    original_title: "When the Tenth Month Comes",
    tmdb_id: 118432,
    overview: "Nỗi đau của người phụ nữ nông thôn miền Bắc Việt Nam có chồng hy sinh ngoài mặt trận trong những năm tháng chiến tranh.",
    movie_type: :single_movie,
    release_year: 1984,
    country: "VN",
    duration: 90,
    vote_average: 7.6,
    vote_count: 45,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/w118432.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b118432.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    genre_names: ["Tâm lý", "Lịch sử", "Chiến tranh"]
  },
  {
    title: "Lật Mặt 7: Một Điều Ước",
    original_title: "Face Off 7: One Wish",
    tmdb_id: 1269382,
    overview: "Câu chuyện gia đình cảm động về người mẹ già 73 tuổi một mình nuôi 5 người con khôn lớn rồi bị đùn đẩy trách nhiệm phụng dưỡng.",
    movie_type: :single_movie,
    release_year: 2024,
    country: "VN",
    duration: 138,
    vote_average: 7.5,
    vote_count: 320,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/w1269382.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b1269382.jpg",
    trailer_url: "https://www.youtube.com/watch?v=d_k8k6d8q9s",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    genre_names: ["Gia đình", "Tâm lý", "Hài hước"]
  },
  {
    title: "Cương Thi Tiên Sinh",
    original_title: "Mr. Vampire",
    tmdb_id: 26038,
    overview: "Thầy pháp Cửu Thúc cùng hai đệ tử vụng về đối phó với xác ướp sống dậy trở thành cương thi nguy hiểm.",
    movie_type: :single_movie,
    release_year: 1985,
    country: "CN",
    duration: 96,
    vote_average: 7.3,
    vote_count: 310,
    age_rating: "C16",
    poster_url: "https://image.tmdb.org/t/p/w500/w26038.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b26038.jpg",
    trailer_url: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    genre_names: ["Kinh dị", "Hài hước", "Võ thuật"]
  },
  {
    title: "Đội Cứu Hộ Bờ Biển",
    original_title: "Baywatch",
    tmdb_id: 339846,
    overview: "Trưởng nhóm cứu hộ Mitch Buchannon đụng độ cựu vận động viên Olympic ngang bướng trước khi cùng nhau lật tẩy đường dây ma túy.",
    movie_type: :single_movie,
    release_year: 2017,
    country: "US",
    duration: 116,
    vote_average: 5.8,
    vote_count: 8100,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w339846.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b339846.jpg",
    trailer_url: "https://www.youtube.com/watch?v=eyKOgZ33984",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    genre_names: ["Hài hước", "Hành động"]
  },
  {
    title: "Hố Sâu Đói Khát",
    original_title: "The Platform",
    tmdb_id: 619264,
    overview: "Nhà tù thẳng đứng nơi bàn tiệc đầy ắp thức ăn hạ dần từng tầng, khiến những tù nhân tầng dưới phải chịu cảnh đói khát cùng cực.",
    movie_type: :single_movie,
    release_year: 2019,
    country: "US",
    duration: 94,
    vote_average: 7.0,
    vote_count: 7200,
    age_rating: "C18",
    poster_url: "https://image.tmdb.org/t/p/w500/w619264.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b619264.jpg",
    trailer_url: "https://www.youtube.com/watch?v=RlfooqeZcdY",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    genre_names: ["Khoa học viễn tưởng", "Kinh dị", "Tâm lý"]
  },
  {
    title: "Góc Khuất",
    original_title: "The Blind Side",
    tmdb_id: 22881,
    overview: "Câu chuyện có thật cảm động về cậu thiếu niên vô gia cư da màu được một gia đình da trắng giàu có nhận nuôi và trở thành ngôi sao bóng bầu dục.",
    movie_type: :single_movie,
    release_year: 2009,
    country: "US",
    duration: 129,
    vote_average: 7.7,
    vote_count: 6500,
    age_rating: "P",
    poster_url: "https://image.tmdb.org/t/p/w500/w22881.jpg",
    banner_url: "https://image.tmdb.org/t/p/original/b22881.jpg",
    trailer_url: "https://www.youtube.com/watch?v=gw5u2bY0HnA",
    video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    genre_names: ["Tâm lý", "Gia đình"]
  }
]

movies_data.each do |data|
  genre_names = data.delete(:genre_names)
  movie = Movie.find_or_initialize_by(tmdb_id: data[:tmdb_id])
  movie.update!(data.merge(is_published: true))

  selected_genres = genre_names.map { |name| genres[name] }.compact
  movie.genres = selected_genres
end

# --- 4. SEED PEOPLE & CREDITS (DIEN VIEN & DAO DIEN) ---
puts "4. Seeding people & movie credits..."

people_data = [
  { name: "Anthony Russo", tmdb_person_id: 19271, profile_url: "https://image.tmdb.org/t/p/w200/tc0hT9wT1pXyFmQzP61a4n7J61B.jpg" },
  { name: "Joe Russo", tmdb_person_id: 19272, profile_url: "https://image.tmdb.org/t/p/w200/jZc8o4YlM7qP8G3A7c91D61k72C.jpg" },
  { name: "Christopher Nolan", tmdb_person_id: 525, profile_url: "https://image.tmdb.org/t/p/w200/xuAIuYSmsUzKlUMBFGVZaWsY3Z5.jpg" },
  { name: "Bong Joon-ho", tmdb_person_id: 21684, profile_url: "https://image.tmdb.org/t/p/w200/10gAkg7a25j4F58W714C8k81K.jpg" },
  { name: "Vince Gilligan", tmdb_person_id: 66633, profile_url: "https://image.tmdb.org/t/p/w200/rL66A3X4b9k71F7wP91a4c9.jpg" },

  { name: "Robert Downey Jr.", tmdb_person_id: 3223, profile_url: "https://image.tmdb.org/t/p/w200/5qHNjhtjMD4YWH3UP0rm4tKwxCL.jpg" },
  { name: "Chris Evans", tmdb_person_id: 16828, profile_url: "https://image.tmdb.org/t/p/w200/3bOGNsHlrswhyW79uvIHH1V43JI.jpg" },
  { name: "Scarlett Johansson", tmdb_person_id: 1245, profile_url: "https://image.tmdb.org/t/p/w200/6NsMbJXRlDZuDzatQT8rq49a6.jpg" },
  { name: "Matthew McConaughey", tmdb_person_id: 10297, profile_url: "https://image.tmdb.org/t/p/w200/wDeL9b0FpE2e71J8Kk62D.jpg" },
  { name: "Anne Hathaway", tmdb_person_id: 1813, profile_url: "https://image.tmdb.org/t/p/w200/tLsplEgOOcasFMB95g1.jpg" },
  { name: "Song Kang-ho", tmdb_person_id: 20738, profile_url: "https://image.tmdb.org/t/p/w200/f83827FqM91aK3829L98k.jpg" },
  { name: "Bryan Cranston", tmdb_person_id: 17419, profile_url: "https://image.tmdb.org/t/p/w200/7Jahy5LZX2Fo4fGJltMgnAI.jpg" },
  { name: "Aaron Paul", tmdb_person_id: 84497, profile_url: "https://image.tmdb.org/t/p/w200/8pK7192KaM971L03K8k.jpg" }
]

people = {}
people_data.each do |p_data|
  person = Person.find_or_initialize_by(name: p_data[:name])
  person.update!(p_data)
  people[p_data[:name]] = person
end

# Gan vao Avengers: Hoi Ket
avengers = Movie.find_by(title: "Avengers: Hồi Kết")
if avengers
  MovieCredit.find_or_create_by!(movie: avengers, person: people["Anthony Russo"], credit_type: :crew, job: "Đạo diễn")
  MovieCredit.find_or_create_by!(movie: avengers, person: people["Joe Russo"], credit_type: :crew, job: "Đạo diễn")
  MovieCredit.find_or_create_by!(movie: avengers, person: people["Robert Downey Jr."], credit_type: :cast, character_name: "Tony Stark / Iron Man", order_index: 0)
  MovieCredit.find_or_create_by!(movie: avengers, person: people["Chris Evans"], credit_type: :cast, character_name: "Steve Rogers / Captain America", order_index: 1)
  MovieCredit.find_or_create_by!(movie: avengers, person: people["Scarlett Johansson"], credit_type: :cast, character_name: "Natasha Romanoff / Black Widow", order_index: 2)
end

# Gan vao Ho Den Tu Than
interstellar = Movie.find_by(title: "Hố Đen Tử Thần")
if interstellar
  MovieCredit.find_or_create_by!(movie: interstellar, person: people["Christopher Nolan"], credit_type: :crew, job: "Đạo diễn & Biên kịch")
  MovieCredit.find_or_create_by!(movie: interstellar, person: people["Matthew McConaughey"], credit_type: :cast, character_name: "Joseph Cooper", order_index: 0)
  MovieCredit.find_or_create_by!(movie: interstellar, person: people["Anne Hathaway"], credit_type: :cast, character_name: "Dr. Amelia Brand", order_index: 1)
end

# --- 5. SEED TAP PHIM (SERIES EPISODES) ---
puts "5. Seeding episodes for series movies..."

series_movies = Movie.where(movie_type: :series)
sample_videos = [
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
]

series_movies.each do |series|
  (1..6).each do |ep_num|
    Episode.find_or_create_by!(
      movie: series,
      season_number: 1,
      episode_number: ep_num
    ) do |ep|
      ep.title = "Tập #{ep_num}: Diễn biến kịch tính"
      ep.duration = 45 + ep_num * 3
      ep.video_url = sample_videos[(ep_num - 1) % sample_videos.length]
    end
  end
end

# --- 6. SEED WATCHLISTS CHO USER ---
puts "6. Seeding watchlists for user..."

normal_user = User.find_by(email: "dongxuanduc2005@gmail.com")
if normal_user
  all_movies = Movie.where(is_published: true).limit(9)

  # 3 phim Dang xem
  all_movies[0..2].each do |m|
    w = Watchlist.find_or_initialize_by(user: normal_user, movie: m)
    w.update!(status: :watching)
  end

  # 3 phim Mong muon
  all_movies[3..5].each do |m|
    w = Watchlist.find_or_initialize_by(user: normal_user, movie: m)
    w.update!(status: :plan_to_watch)
  end

  # 3 phim Da xem xong
  all_movies[6..8].each do |m|
    w = Watchlist.find_or_initialize_by(user: normal_user, movie: m)
    w.update!(status: :completed)
  end
end

puts "
🎉 Done! Seeded successfully:"
puts "- Users: #{User.count}"
puts "- Genres: #{Genre.count}"
puts "- Movies: #{Movie.count}"
puts "- People (Cast & Crew): #{Person.count}"
puts "- MovieCredits: #{MovieCredit.count}"
puts "- Episodes: #{Episode.count}"
puts "- Watchlists: #{Watchlist.count}"