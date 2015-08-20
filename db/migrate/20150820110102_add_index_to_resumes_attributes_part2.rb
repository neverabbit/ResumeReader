class AddIndexToResumesAttributesPart2 < ActiveRecord::Migration
  def change
    add_index :resumes, :comment, length: 200
    add_index :resumes, :commented_at
  end
end
