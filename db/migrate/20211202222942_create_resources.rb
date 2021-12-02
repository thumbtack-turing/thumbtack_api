class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.string :url
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
