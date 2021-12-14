module Mutations
    module Resources
      class DeleteResource < GraphQL::Schema::Mutation
        argument :id, ID, required: true

        field :parent_folder, Types::FolderType, null: true
        field :errors, [String], null: false

        def resolve(id:)
          resource = Resource.find(id)
          folder_id = resource.folder.id
          resource.destroy
          Folder.find(folder_id)

        rescue ActiveRecord::RecordNotFound => _e
          GraphQL::ExecutionError.new("Invalid resource id.")
        end
      end
    end
  end