class AddTotalRatingsToPlace < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :total_ratings, :integer
  end
end
