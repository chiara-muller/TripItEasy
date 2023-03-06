class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.float :ratings
      t.string :photos
      t.float :latitude
      t.float :longitude
      t.string :google_place_id

      t.timestamps
    end
  end
end
