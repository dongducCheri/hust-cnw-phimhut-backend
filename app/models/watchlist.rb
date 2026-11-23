class Watchlist < ApplicationRecord
  belongs_to :user 
  belongs_to :movie 

  enum :status, {plan_to_watch: 0, watching: 1, completed: 2}, default: :plan_to_watch 
  validates :status, presence: true
  validates :movie_id, uniqueness: { scope: :user_id, message: "Already in your list" }
end
