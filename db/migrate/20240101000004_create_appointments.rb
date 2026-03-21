class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments, id: :uuid do |t|
      t.references :ward, null: false, foreign_key: true, type: :uuid
      t.date    :scheduled_date, null: false
      t.string  :family_name,    null: false
      t.string  :phone
      t.boolean :reminder_sent,  default: false, null: false
      t.timestamps
    end
    add_index :appointments, [:ward_id, :scheduled_date], unique: true
  end
end
