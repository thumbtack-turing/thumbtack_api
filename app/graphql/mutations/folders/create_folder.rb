class Mutations::Folders::CreateFolder < GraphQL::Schema::Mutation
  argument :name, String, required: true
  argument :parent_id, ID, required: true
  argument :user_id, ID, required: true

  type Types::FolderType

  field :new_folder, Types::FolderType
  field :parent_folder, Types::FolderType

  def resolve(attributes)
    user = User.find(attributes[:user_id])
    parent = Folder.find(attributes[:parent_id])
    folder = user.folders.create(name: attributes[:name], parent_id: attributes[:parent_id])
    if folder.save
      {
        new_folder: folder,
        parent_folder: parent
      }
    else
      raise GraphQL::ExecutionError, folder.errors.full_messages.join(", ")
    end
  rescue ActiveRecord::RecordNotFound => _e
    GraphQL::ExecutionError.new("Invalid user or folder id.")
  end
end
