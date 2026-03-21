class Ward < ApplicationRecord
  belongs_to :stake
  belongs_to :user
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :public_token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  def upcoming_appointments
    appointments.where("scheduled_date >= ?", Date.today).order(:scheduled_date)
  end

  def date_taken?(date)
    appointments.exists?(scheduled_date: date)
  end

  private

  def generate_token
    self.public_token ||= loop do
      token = SecureRandom.urlsafe_base64(16)
      break token unless Ward.exists?(public_token: token)
    end
  end
end
