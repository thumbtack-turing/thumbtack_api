class Types::FolderType < Types::BaseObject
    description "A folder"

    field :id, ID, null: false
    field :name, String, null: false
    field :base, Boolean, null: false
    field :parent_id, ID, null: true

    field :child_folders, [Types::FolderType], null: true

    def child_folders
        object.folders.order("lower(name)")
    end

    field :child_resources, [Types::ResourceType], null: true

    def child_resources
        object.resources.order("lower(name)")
    end

    field :file_path, String, null: false

    def file_path
      object.create_file_path("")
    end
end
