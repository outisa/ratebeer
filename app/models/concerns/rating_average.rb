module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    avg = ratings.pluck(:score).reduce(0) { |s, score| s + score } / ratings.count.to_f
    avg.to_f.round(1)
  end
end
