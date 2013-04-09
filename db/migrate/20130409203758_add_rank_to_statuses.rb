class AddRankToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :rank, :integer
  end
end
