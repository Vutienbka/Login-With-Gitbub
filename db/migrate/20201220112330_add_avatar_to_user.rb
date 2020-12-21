class AddAvatarToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avartar, :String
  end
end
