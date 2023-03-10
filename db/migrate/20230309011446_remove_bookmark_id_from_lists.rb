class RemoveBookmarkIdFromLists < ActiveRecord::Migration[7.0]
  def change
    remove_column :lists, :bookmark_id, :bigint
  end
end
