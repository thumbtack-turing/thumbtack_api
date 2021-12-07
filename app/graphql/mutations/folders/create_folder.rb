class Mutations::Folders::CreateFolder < Mutations::BaseMutation
  argument :name, String, required: true
  argument :parent_id, ID, required: true
  argument :user_id, ID, required: true

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
    end
  end
end
