class ChangeColumnDefault < ActiveRecord::Migration[7.0]
  def change
    Beer.find_each do |beer|
      beer.style = Style.find_by(name: beer.old_style)
      beer.save
    end
  end
end
