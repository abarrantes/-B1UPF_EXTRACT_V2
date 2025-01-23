class XmlDocumentsController < ApplicationController
  def index
    @xml_documents = XmlDocument.all
  end

  def new
    @xml_document = XmlDocument.new
  end

  def create
    @xml_document = XmlDocument.new(xml_document_params)
    @xml_document.filename = xml_document_params[:file].original_filename

    if @xml_document.save
      parse_and_store_xml
      redirect_to xml_documents_path, notice: "XML file was successfully uploaded and parsed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @xml_document = XmlDocument.find(params[:id])
  end

  def parse_users
    @xml_document = XmlDocument.find(params[:id])
    if @xml_document.parse_and_store_users
      redirect_to license_users_path, notice: "Users were successfully parsed from XML"
    else
      redirect_to license_users_path, alert: "Failed to parse users from XML"
    end
  end

  private

  def xml_document_params
    params.require(:xml_document).permit(:file)
  end

  def parse_and_store_xml
    xml_content = @xml_document.file.download
    parsed_data = Hash.from_xml(xml_content)
    @xml_document.update(parsed_content: parsed_data)
  rescue StandardError => e
    @xml_document.errors.add(:base, "XML parsing failed: #{e.message}")
    false
  end
end
