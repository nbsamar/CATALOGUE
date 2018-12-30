class CreateProductTags < ActiveRecord::Migration[5.2]
  def change
    create_table :product_tags, id: false do |t|
      t.integer :product_id, index: true
      t.integer :tag_id, index: true
      t.timestamps
    end
    add_index(:product_tags, [:product_id, :tag_id])
  end
end
