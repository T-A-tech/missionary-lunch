class Stake < ApplicationRecord
  has_many :wards, dependent: :destroy

  validates :name, presence: true
end
