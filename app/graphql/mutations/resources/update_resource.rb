class Mutations::Resources::UpdateResource < GraphQL::Schema::Mutation
  argument :id, ID, required: true
  argument :name, String, required: false
  argument :folder_id, ID, required: true
  argument :new_folder_id, ID, required: false

  type Types::ResourceType

  field :updated_resource, Types::ResourceType, null: false
  field :original_parent, Types::FolderType, null: false

  def resolve(attributes)
    resource = Resource.find(attributes[:id])
    parent = Folder.find(resource.folder_id)
    resource.update(name: attributes[:name]) if attributes[:name]
    resource.update(folder_id: attributes[:new_folder_id])  if attributes[:new_folder_id]
    {
      updated_resource: resource,
      original_parent: parent
    }
  rescue ActiveRecord::RecordNotFound => _e
    GraphQL::ExecutionError.new("Invalid resource or folder id.")
  end
end
