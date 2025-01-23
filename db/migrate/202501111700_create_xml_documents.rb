class CreateXmlDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :xml_documents do |t|
      t.string :filename
      t.json :parsed_content
      t.timestamps
    end
  end
end
