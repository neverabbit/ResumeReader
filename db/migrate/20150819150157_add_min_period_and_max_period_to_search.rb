class AddMinPeriodAndMaxPeriodToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :min_period, :integer
    add_column :searches, :max_period, :integer
  end
end
