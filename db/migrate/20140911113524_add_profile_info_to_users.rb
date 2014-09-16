class AddProfileInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_id, :string
  end
end
