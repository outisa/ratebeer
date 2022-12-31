module Top
  extend ActiveSupport::Concern

  def self.calculate_top(item, how_many)
    sorted_by_rating_in_desc_order = item.all.sort_by(&:average_rating).reverse!
    sorted_by_rating_in_desc_order[0..(how_many - 1)]
  end
end
