module Types
  class MutationType < Types::BaseObject
    field :create_user, Types::UserType, mutation: Mutations::Users::CreateUser
    field :create_folder, mutation: Mutations::Folders::CreateFolder
  end
end
