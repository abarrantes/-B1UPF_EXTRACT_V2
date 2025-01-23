class XmlDocument < ApplicationRecord
  has_one_attached :file
  has_many :license_users, dependent: :destroy

  validates :file, presence: true
  validate :file_must_be_xml

  def parse_and_store_users
    return unless file.attached?

    # First convert XML to Hash using ActiveSupport's Hash.from_xml
    xml_content = file.download
    # Remove BOM if present
    xml_content = xml_content.force_encoding("UTF-8").sub("\xEF\xBB\xBF", "")
    data = Hash.from_xml(xml_content)

    if data["Users"] && data["Users"]["User"]
      users = data["Users"]["User"]
      users = [ users ] unless users.is_a?(Array)

      users.each do |user_data|
        license_user = LicenseUser.from_json(user_data, self)
        license_user.save!
      end
    end
  end

  private

  def file_must_be_xml
    return unless file.attached?

    unless file.content_type == "application/xml" || file.content_type == "text/xml"
      errors.add(:file, "must be an XML file")
    end
  end
end
