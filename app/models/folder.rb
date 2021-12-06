class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :folder_resources, dependent: :destroy
  has_many :resources, through: :folder_resources
  has_many :folders, class_name: 'Folder', foreign_key: :parent_id
end
