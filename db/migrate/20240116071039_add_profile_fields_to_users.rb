class AddProfileFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :profile_picture, :string
    add_column :users, :cover_photo, :string
    add_column :users, :bio, :text
  end
end
