class LicenseModule < ApplicationRecord
  belongs_to :license_user

  validates :key_type, presence: true
  validates :key_type, uniqueness: { scope: [ :license_user_id, :install_no ] }
end
