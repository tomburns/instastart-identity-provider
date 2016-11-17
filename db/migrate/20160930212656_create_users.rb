class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.string :display_name
      t.string :avatar_url
      t.boolean :is_admin, null: false, default: false
    end
    add_index :users, :email
  end
end
