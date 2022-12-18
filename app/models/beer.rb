class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average_rating
    id = ratings.first.beer_id
    avg = Rating.where(beer_id: id).pluck(:score).reduce(0) {|s, score| s+score} /ratings.count
    avg.to_f
  end

  def to_s
    "#{name}, #{brewery.name}"

  end
end
