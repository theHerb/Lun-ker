class AddHomePageToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :home_page, :boolean, :default => false
  end
end
