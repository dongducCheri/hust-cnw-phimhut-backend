# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_26_081354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "episodes", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.integer "season_number", default: 1, null: false
    t.integer "episode_number", null: false
    t.string "title", null: false
    t.integer "duration"
    t.string "video_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_episodes_on_movie_id"
  end

  create_table "genres", force: :cascade do |t|
    t.integer "tmdb_genre_id"
    t.string "name", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
    t.index ["slug"], name: "index_genres_on_slug", unique: true
    t.index ["tmdb_genre_id"], name: "index_genres_on_tmdb_genre_id", unique: true
  end

  create_table "movie_credits", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "person_id", null: false
    t.integer "credit_type", default: 0, null: false
    t.string "job"
    t.string "character_name"
    t.integer "order_index", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_movie_credits_on_movie_id"
    t.index ["person_id"], name: "index_movie_credits_on_person_id"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_movie_genres_on_genre_id"
    t.index ["movie_id"], name: "index_movie_genres_on_movie_id"
  end

  create_table "movies", force: :cascade do |t|
    t.integer "tmdb_id"
    t.string "title", null: false
    t.string "original_title"
    t.text "overview"
    t.integer "movie_type", default: 0, null: false
    t.integer "release_year"
    t.string "country"
    t.integer "duration"
    t.float "vote_average", default: 0.0
    t.integer "vote_count", default: 0
    t.string "age_rating"
    t.string "poster_url"
    t.string "banner_url"
    t.string "trailer_url"
    t.string "video_url"
    t.boolean "is_published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.integer "tmdb_person_id"
    t.string "name", null: false
    t.string "profile_url"
    t.integer "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.integer "balance", default: 0, null: false
    t.boolean "is_locked", default: false, null: false
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "watchlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "movie_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_watchlists_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_watchlists_on_user_id_and_movie_id", unique: true
    t.index ["user_id", "status"], name: "index_watchlists_on_user_id_and_status"
    t.index ["user_id"], name: "index_watchlists_on_user_id"
  end

  add_foreign_key "episodes", "movies"
  add_foreign_key "movie_credits", "movies"
  add_foreign_key "movie_credits", "people"
  add_foreign_key "movie_genres", "genres"
  add_foreign_key "movie_genres", "movies"
  add_foreign_key "watchlists", "movies"
  add_foreign_key "watchlists", "users"
end
