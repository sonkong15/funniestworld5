class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.text :bio
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token
      t.boolean :admin
      t.string :website_link
      t.string :facebook_link
      t.string :facebook_uid
      t.string :image_url
      t.string :location
      t.string :facebook_url
      t.string :last_name


      t.timestamps
    end
  end
end
