class AddCommentIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :comment_id, :integer
    add_column :comments, :reply_id, :integer
  end
end
