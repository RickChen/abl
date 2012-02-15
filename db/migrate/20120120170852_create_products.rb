class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :batt_life
      t.string :purchase_date
      t.integer :user_id

      t.timestamps
    end
  end
end
