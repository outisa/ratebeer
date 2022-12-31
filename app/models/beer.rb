class Beer < ApplicationRecord
  include RatingAverage
  extend Top

  validates :name, length: { minimum: 1 }
  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def self.top(how_many)
    Top.calculate_top(Beer, how_many)
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
