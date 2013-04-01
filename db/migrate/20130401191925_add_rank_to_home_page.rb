class AddRankToHomePage < ActiveRecord::Migration
  def change
    add_column :photos, :rank, :integer
  end
end
