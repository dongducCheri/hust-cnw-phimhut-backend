class MovieCredit < ApplicationRecord
  belongs_to :movie
  belongs_to :person
  enum :credit_type, { cast: 0, crew: 1 }, default: :cast
  validates :credit_type, presence: true
end
