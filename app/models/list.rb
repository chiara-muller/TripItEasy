class List < ApplicationRecord
  belongs_to :user
  has_many :bookmarks

  validates :name, presence: true
end
