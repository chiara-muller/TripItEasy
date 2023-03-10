class Place < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :bookmarks
  has_many :users, through: :bookmarks

  def show
    @place = Place.first
  end
end
