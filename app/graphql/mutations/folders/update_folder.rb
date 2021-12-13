class Mutations::Folders::UpdateFolder < GraphQL::Schema::Mutation
  argument :id, ID, required: true
  argument :new_parent_id, ID, required: false
  argument :name, String, required: false

  type Types::FolderType

  field :updated_folder, Types::FolderType, null: true
  field :original_parent, Types::FolderType, null: true

  def resolve(attributes)
    folder = Folder.find(attributes[:id])
    og_parent = Folder.find(folder.parent_id)

    if attributes[:new_parent_id] && attributes[:name]
      folder.update(parent_id: attributes[:new_parent_id], name: attributes[:name])
    elsif attributes[:new_parent_id]
      folder.update(parent_id: attributes[:new_parent_id])
    elsif attributes[:name]
      folder.update(name: attributes[:name])
    else
      raise GraphQL::ExecutionError, "Name or new parent id required."
    end

    {
      updated_folder: folder,
      original_parent: og_parent
    }
  rescue ActiveRecord::RecordNotFound => _e
    GraphQL::ExecutionError.new("Invalid folder id.")
  end
end
