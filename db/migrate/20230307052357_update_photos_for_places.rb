class UpdatePhotosForPlaces < ActiveRecord::Migration[7.0]
  def change
    remove_column :places, :photos, :string
    add_column :places, :photos, :jsonb
  end
end
