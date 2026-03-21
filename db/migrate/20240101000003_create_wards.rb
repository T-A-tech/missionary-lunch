class CreateWards < ActiveRecord::Migration[7.2]
  def change
    create_table :wards do |t|
      t.references :stake, null: false, foreign_key: true
      t.references :user,  null: false, foreign_key: true
      t.string :name,         null: false
      t.string :public_token, null: false
      t.timestamps
    end
    add_index :wards, :public_token, unique: true
  end
end
