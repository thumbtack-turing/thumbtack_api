class Mutations::Folders::UpdateFolder < GraphQL::Schema::Mutation
  argument :id, ID, required: true
  argument :new_parent_id, ID, required: false
  argument :name, String, required: false

  type Types::FolderType

  field :updated_folder, Types::FolderType, null: true
  field :original_parent, Types::FolderType, null: true
  field :errors, [String], null: false

  def resolve(attributes)
    folder = Folder.find(attributes[:id])
    og_parent = Folder.find(folder.parent_id)
    errors = []

    if attributes[:new_parent_id] && attributes[:name]
      folder.update(parent_id: attributes[:new_parent_id], name: attributes[:name])
    elsif attributes[:new_parent_id]
      folder.update(parent_id: attributes[:new_parent_id])
    elsif attributes[:name]
      folder.update(name: attributes[:name])
    else
      errors = ["Name or new parent id required."]
    end

    {
      updated_folder: folder,
      original_parent: og_parent,
      errors: errors
    }
  end
end
