module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    avg = ratings.pluck(:score).reduce(0) {|s, score| s+score} /ratings.count
    avg.to_f.round(2)
  end
end