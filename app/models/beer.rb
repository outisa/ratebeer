class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    avg = ratings.sum(:score)/ratings.count 
    avg.to_f
  end
end
