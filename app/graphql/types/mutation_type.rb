module Types
  class MutationType < Types::BaseObject

    field :create_user, UserType, null: true, description: 'Create a user' do
      argument :name, String, required: true
      argument :email, String, required: true
    end

    def create_user(name:, email:)
      user = User.create(name: name, email: email)
      user.folders.create(name: "Base Folder", base: true)
      user
    end
  end
end
