class Mutations::Users::DeleteUser < GraphQL::Schema::Mutation
  argument :id, ID, required: true

  type Types::UserType

  def resolve(attributes)
    user = User.find_by(id: attributes[:id])
    if user
      user.destroy
    else
      raise GraphQL::ExecutionError, "User does not exist"
    end
  end
end
