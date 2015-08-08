class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :city
      t.string :phone
      t.string :position
      t.text :quality
      t.text :education
      t.text :experience
      t.string :period

      t.timestamps null: false
    end
  end
end
