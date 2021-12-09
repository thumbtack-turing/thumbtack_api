module Types
  class MutationType < Types::BaseObject

    field :create_user, Types::UserType, mutation: Mutations::Users::CreateUser
    field :delete_user, Types::UserType, mutation: Mutations::Users::DeleteUser

    field :create_resource, Types::FolderType, mutation: Mutations::Resources::CreateResource
    field :update_resource, Types::ResourceType, mutation: Mutations::Resources::UpdateResource
    field :delete_resource, Types::FolderType, mutation: Mutations::Resources::DeleteResource
    
    field :create_folder, Types::FolderType, mutation: Mutations::Folders::CreateFolder
    field :update_folder, Types::FolderType, mutation: Mutations::Folders::UpdateFolder
    field :delete_folder, Types::FolderType, mutation: Mutations::Folders::DeleteFolder
  end
end
