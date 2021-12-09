class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :resources, dependent: :destroy
  has_many :folders, class_name: 'Folder', foreign_key: :parent_id

  def create_file_path(string)
    if parent_id.nil?
      folder = name.gsub(" ", "-")
      string.prepend("/#{folder}")
      return string
    else
      parent_folder = Folder.find(parent_id)
      formatted_name = name.gsub(" ", "-")
      string.prepend("/#{formatted_name}")
      parent_folder.create_file_path(string)
    end
  end
end
