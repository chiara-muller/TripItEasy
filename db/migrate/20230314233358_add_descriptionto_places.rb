class AddDescriptiontoPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :desciption, :text
  end
end
