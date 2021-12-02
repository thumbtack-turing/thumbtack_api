class CreateFolderResources < ActiveRecord::Migration[6.1]
  def change
    create_table :folder_resources do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
