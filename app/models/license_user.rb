class LicenseUser < ApplicationRecord
  paginates_per 20

  belongs_to :xml_document
  has_many :license_modules, dependent: :destroy

  validates :user_name, presence: true
  validates :user_name, uniqueness: { scope: :xml_document_id }

  def self.from_json(json, xml_document)
    user = new(
      user_name: json["UserName"],
      is_connected: json["IsConnected"] == "1",
      xml_document: xml_document
    )

    if json["Modules"] && json["Modules"]["Module"]
      modules = json["Modules"]["Module"]
      modules = [ modules ] unless modules.is_a?(Array)

      modules.each do |module_data|
        user.license_modules.build(
          key_type: module_data["KeyType"],
          key_desc: module_data["KeyDesc"],
          db_type: module_data["DbType"],
          bitmask_of_licensed_modules: module_data["BitmaskOfLicensedModules"],
          refering_count: module_data["ReferingCount"],
          install_no: module_data["InstallNo"]
        )
      end
    end

    user
  end
end
