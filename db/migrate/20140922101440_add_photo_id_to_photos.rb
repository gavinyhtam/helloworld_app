class AddPhotoIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :photo_id, :string
  end
end
