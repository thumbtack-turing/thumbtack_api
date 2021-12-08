class Mutations::Resources::UpdateResource < GraphQL::Schema::Mutation
  argument :id, ID, required: true
  argument :name, String, required: false
  argument :folder_id, ID, required: true
  argument :new_folder_id, ID, required: false

  def resolve(attributes)
    resource = Resource.find(attributes[:id])
    resource.update(name: attributes[:name]) if attributes[:name]
    resource.update(folder_id: attributes[:new_folder_id])  if attributes[:new_folder_id]
    # binding.pry
    resource
  end
end
