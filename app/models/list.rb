class List < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy

  validates :name, presence: true
end
