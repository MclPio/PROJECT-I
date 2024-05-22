class Calendar < ApplicationRecord
  belongs_to :user

  validates :calendar_id, presence: true, uniqueness: true
  validates :user, presence: true
end
