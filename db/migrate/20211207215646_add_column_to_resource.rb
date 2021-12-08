class AddColumnToResource < ActiveRecord::Migration[6.1]
  def change
    add_reference :resources, :folder, foreign_key: true
  end
end
