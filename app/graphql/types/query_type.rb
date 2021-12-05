module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
                               description: 'An example field added by the generator'
    def test_field
      'Hello World!'
    end

    field :get_user, Types::UserType, null: true,
        description: 'One user' do
          argument :email, String, required: true
        end

    def get_user(email:)
      User.find_by(email: email)
    end
    
    field :get_folder, Types::FolderType, null: true,
        description: 'One folder' do
          argument :id, ID, required: true
        end

    def get_folder(id:)
      Folder.find(id)
    end
  end
end
