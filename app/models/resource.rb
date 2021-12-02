class Resource < ApplicationRecord
  has_many :folder_resources, dependent: :destroy
  has_many :folders, through: :folder_resources
end
