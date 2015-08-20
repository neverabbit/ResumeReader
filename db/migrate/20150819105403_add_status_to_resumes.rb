class AddStatusToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :comment, :text
    add_column :resumes, :commented_at, :datetime
  end
end
