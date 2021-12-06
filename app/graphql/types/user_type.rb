class Types::UserType < Types::BaseObject
    description "A user"

    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :base_folder, Types::FolderType, null: false

    def base_folder
      object.base_folder
    end
end
