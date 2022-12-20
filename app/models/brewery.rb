class Brewery < ApplicationRecord
  include RatingAverage
  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1040,
              only_integer: true }
  validate :is_year_in_future

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def is_year_in_future
    if year.present? && year > Time.now.year
      errors.add(:year, 'Year cannot be in the future.')
    end
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
