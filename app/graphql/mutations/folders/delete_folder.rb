class Mutations::Folders::DeleteFolder < GraphQL::Schema::Mutation
  argument :id, ID, required: true

  def resolve(attributes)
      id = attributes[:id]
      folder = Folder.find(id)
      parent = Folder.find(folder.parent_id)
      folder.destroy
      parent

  rescue ActiveRecord::RecordNotFound => _e
    GraphQL::ExecutionError.new("Invalid folder id.")
  end
end
