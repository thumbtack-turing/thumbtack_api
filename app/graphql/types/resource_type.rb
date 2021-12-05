class Types::ResourceType < Types::BaseObject
    description "A resource"

    field :id, ID, null: false
    field :name, String, null: false
    field :url, String, null: false
    field :image, String, null: false
    field :created_at, String , null: false
end