class MakeEncPasswordFieldNullable < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :encrypted_password, :string, null: true
  end
end
