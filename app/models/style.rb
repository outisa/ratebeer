class Style < ApplicationRecord
  validates :name, uniqueness: true,
                   length: { minimum: 3, maximum: 25 }
  has_many :beers
end
