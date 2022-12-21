class ChangeDataTypeForFieldname < ActiveRecord::Migration[7.0]
  def change
    change_table :beer_clubs do |t|
      t.change :founded, :integer
    end
  end
end
