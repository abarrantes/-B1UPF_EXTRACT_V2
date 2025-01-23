class CreateLicenseModules < ActiveRecord::Migration[7.1]
  def change
    create_table :license_modules do |t|
      t.string :key_type, null: false
      t.string :key_desc
      t.string :db_type
      t.string :bitmask_of_licensed_modules
      t.string :refering_count
      t.string :install_no
      t.references :license_user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :license_modules, [ :key_type, :license_user_id, :install_no ], unique: true, name: 'idx_license_modules_unique'
  end
end
