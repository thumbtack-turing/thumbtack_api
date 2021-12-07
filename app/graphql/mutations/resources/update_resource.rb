class Mutations::Resources::UpdateResource < GraphQL::Schema::Mutation
  argument :id, ID, required: true
  argument :url, String, required: false
  argument :name, String, required: false

  def resolve(attributes)
    resource = Resource.find(attributes[:id])
    resource.update(attributes)
    resource
  end
end
