class AddStoryToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :story, :string
  end
end
