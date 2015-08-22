class AddCommentToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :comment, :string
    add_column :searches, :commented_at, :datetime
  end
end
