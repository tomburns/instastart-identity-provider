class ChangeUsersIdToUuid < ActiveRecord::Migration[5.0]
  def change
    enable_extension "uuid-ossp"

    add_column :users, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    change_table :users do |u|
      u.remove :id
      u.rename :uuid, :id
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    change_table :sessions do |s|
      s.remove :user_id
      s.uuid :user_id
    end
  end
end
