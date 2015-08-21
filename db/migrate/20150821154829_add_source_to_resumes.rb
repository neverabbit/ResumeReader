class AddSourceToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :source, :string
    add_index :resumes, :source
  end
end
