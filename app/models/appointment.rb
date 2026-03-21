class Appointment < ApplicationRecord
  belongs_to :ward

  validates :scheduled_date, presence: true
  validates :family_name,    presence: true
  validates :scheduled_date, uniqueness: { scope: :ward_id,
    message: "já tem um almoço agendado nessa data" }
  validate  :date_cannot_be_in_the_past, on: :create

  scope :upcoming, -> { where("scheduled_date >= ?", Date.today).order(:scheduled_date) }
  scope :past,     -> { where("scheduled_date < ?",  Date.today).order(scheduled_date: :desc) }

  private

  def date_cannot_be_in_the_past
    if scheduled_date.present? && scheduled_date < Date.today
      errors.add(:scheduled_date, "não pode ser no passado")
    end
  end
end
