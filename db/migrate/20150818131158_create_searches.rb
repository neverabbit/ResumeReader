class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.string :city
      t.string :phone
      t.string :position
      t.string :quality
      t.string :education
      t.string :experience
      t.string :period

      t.timestamps null: false
    end
  end
end
