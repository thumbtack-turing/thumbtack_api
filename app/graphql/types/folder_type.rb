class Types::FolderType < Types::BaseObject
    description "A folder"

    field :id, ID, null: false
    field :name, String, null: false
    field :base, Boolean, null: false
    field :parent_id, ID, null: false
end