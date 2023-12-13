class AddOtpAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :verified, :boolean, default: false
    add_column :users, :otp, :string
  end
end
