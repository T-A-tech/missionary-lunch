class CreateWards < ActiveRecord::Migration[7.2]
  def change
    create_table :wards, id: :uuid do |t|
      t.references :stake, null: false, foreign_key: true, type: :uuid
      t.references :user,  null: false, foreign_key: true, type: :uuid
      t.string :name,         null: false
      t.string :public_token, null: false
      t.timestamps
    end
    add_index :wards, :public_token, unique: true
  end
end
