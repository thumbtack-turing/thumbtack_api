class Mutations::Users::CreateUser < GraphQL::Schema::Mutation
  null true

  argument :name, String, required: true
  argument :email, String, required: true

  def resolve(name:, email:)
    user = User.new(name: name, email: email)
    if user.save
      user.folders.create(name: "Base", base: true)
      user
    else
      raise GraphQL::ExecutionError, user.error.full_messages.join(", ")
    end
  end
end
