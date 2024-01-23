class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.bigint :commentable_id
      t.string :commentable_type
      t.text :comment

      t.timestamps   
    end
  end
end
