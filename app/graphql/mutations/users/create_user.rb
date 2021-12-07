class Mutations::Users::CreateUser < GraphQL::Schema::Mutation
  null true

  argument :name, String, required: true
  argument :email, String, required: true

  def resolve(name:, email:)
    user = User.create(name: name, email: email)
    user.folders.create(name: "Base", base: true)
    user
  end
end
