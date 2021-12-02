class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Folder'
  has_many :folder_resources, dependent: :destroy
  has_many :resources, through: :folder_resources
end
