class Style < ApplicationRecord
  include RatingAverage
  extend Top

  validates :name, uniqueness: true,
                   length: { minimum: 3, maximum: 25 }
  has_many :beers
  has_many :ratings, through: :beers

  def self.top(how_many)
    Top.calculate_top(Style, how_many)
  end
end
