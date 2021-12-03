class UpdateUserFields < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :national_id, :string
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :is_admin, :boolean
  end
end
