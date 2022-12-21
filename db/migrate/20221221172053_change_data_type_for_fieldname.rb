class ChangeDataTypeForFieldname < ActiveRecord::Migration[7.0]
  def change
    change_column :beer_clubs, :founded, :integer, using: 'founded::integer'
  end
end
