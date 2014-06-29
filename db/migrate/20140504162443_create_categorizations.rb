class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
    	t.integer :upload_id
    	t.integer :category_id

      t.timestamps
    end
    add_index :categorizations, :category_id
    add_index :categorizations, :upload_id
  end
end
