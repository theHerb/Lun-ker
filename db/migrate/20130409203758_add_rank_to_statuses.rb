class AddRankToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :rank, :integer, :default => 1
  end
end
