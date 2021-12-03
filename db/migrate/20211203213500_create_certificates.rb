class CreateCertificates < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.string :name
      t.text :qr_code
      t.references :user, null: false, foreign_key: true
      t.references :uploaded_by, foreign_key: { to_table: 'users' }
      t.timestamps
    end
  end
end
