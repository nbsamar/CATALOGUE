class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.text :name, unique: true, null: false
      t.float :price
      t.timestamps
    end
  end
end
