class User < ApplicationRecord
  has_many :folders, dependent: :destroy
  has_many :resources, through: :folders, dependent: :destroy

  def base_folder
    folders.first
  end
end
