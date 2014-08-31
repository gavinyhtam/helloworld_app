class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :link
      t.string :location_name
      t.string :date
      t.string :user_id

      t.timestamps
    end
  end
end
