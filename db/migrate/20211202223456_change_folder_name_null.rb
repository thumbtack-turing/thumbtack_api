class ChangeFolderNameNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :folders, :name, false
  end
end
