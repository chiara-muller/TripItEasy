class RemoveUserFromBookmark < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookmarks, :user_id, :bigint
  end
end
