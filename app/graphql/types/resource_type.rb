class Types::ResourceType < Types::BaseObject
    description "A resource"

    field :id, ID, null: false
    field :name, String, null: false
    field :url, String, null: false
    field :image, String, null: false
    field :folder_id, ID, null: false
    field :created_at, String , null: false

    field :folder, Types::FolderType, null: true
end
