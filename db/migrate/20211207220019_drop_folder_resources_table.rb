class DropFolderResourcesTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :folder_resources
    
  end
end
