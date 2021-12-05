class AddNullTrueToParentId < ActiveRecord::Migration[6.1]
  def change
    change_column_null :folders, :parent_id, true
  end
end
