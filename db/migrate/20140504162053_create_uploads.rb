class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
    	t.string :title
    	t.text :text
    	t.string :link
    	t.integer :user_id
    	t.string :picture_file_name
    	t.string :picture_content_type
    	t.integer :picture_file_size
    	t.string :slug

      t.timestamps
    end
    add_index :uploads, :user_id 
    add_index :uploads, :slug, unique: true
  end
end
