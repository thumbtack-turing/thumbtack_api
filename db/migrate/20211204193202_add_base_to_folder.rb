class AddBaseToFolder < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :base, :boolean, default: false
  end
end
