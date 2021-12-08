class Mutations::Users::DeleteUser < GraphQL::Schema::Mutation
  argument :id, ID, required: true

  type Types::UserType

  def resolve(attributes)
    user = User.find(attributes[:id])
    user.destroy
  end
end
