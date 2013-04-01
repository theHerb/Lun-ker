class AddRankToHomePage < ActiveRecord::Migration
  def change
    add_column :photos, :rank, :integer, :default => 1
  end
end
