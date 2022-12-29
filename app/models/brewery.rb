class Brewery < ApplicationRecord
  include RatingAverage
  validates :name, length: { minimum: 1 }
  validates :year, numericality: {  greater_than_or_equal_to: 1040,
                                    only_integer: true }
  validate :year_in_future

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_in_future
    return unless year.present? && year > Time.now.year

    errors.add(:year, 'Year cannot be in the future.')
  end

  def self.top(nbr)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by(&:average_rating).reverse!
    sorted_by_rating_in_desc_order[0..(nbr - 1)]
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end
end
