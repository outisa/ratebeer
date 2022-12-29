class Style < ApplicationRecord
  include RatingAverage

  validates :name, uniqueness: true,
                   length: { minimum: 3, maximum: 25 }
  has_many :beers
  has_many :ratings, through: :beers

  def self.top(nbr)
    sorted_by_rating_in_desc_order = Style.all.sort_by(&:average_rating).reverse!
    sorted_by_rating_in_desc_order[0..(nbr - 1)]
  end
end
