class Beer < ApplicationRecord
  include RatingAverage

  validates :name, length: { minimum: 1 }
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def self.top(nbr)
    sorted_by_rating_in_desc_order = Beer.all.sort_by(&:average_rating).reverse!
    sorted_by_rating_in_desc_order[0..(nbr - 1)]
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
