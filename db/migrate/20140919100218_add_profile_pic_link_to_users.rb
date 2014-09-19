class AddProfilePicLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_pic_link, :string
  end
end
