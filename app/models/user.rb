class User < ApplicationRecord
  has_many :folders, dependent: :destroy
  has_many :resources, through: :folders, dependent: :destroy
end
