class CreateLicenseUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :license_users do |t|
      t.string :user_name, null: false
      t.boolean :is_connected
      t.references :xml_document, null: false, foreign_key: true

      t.timestamps
    end

    add_index :license_users, [ :user_name, :xml_document_id ], unique: true
  end
end
