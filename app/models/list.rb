class List < ApplicationRecord
  belongs_to :user_id
  belongs_to :bookmark_id

  validates :name, presence: true
end
