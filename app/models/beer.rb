class Beer < ApplicationRecord
  include RatingAverage
  validates :name, length: { minimum: 1 }
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def to_s
    "#{name}, #{brewery.name}"
  end
end
