require 'rails_helper'

RSpec.describe Mutations::Folders::CreateFolder, type: :request do
  before(:each) do
    @user = User.create(name: 'Navani', email: 'storms@example.com')
    @folder = @user.folders.create(name: 'navani_base', base: true)
  end
  describe '.resolve' do
    it 'creates a folder' do
      expect(Folder.count).to eq(1)
      post '/graphql', params: {query: query}
      expect(Folder.count).to eq(2)
    end

    it 'returns new folder' do
      post '/graphql', params: {query: query}
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:folders][:newFolder][:name]).to eq("Dalinar")
      expect(json[:data][:folders][:newFolder][:base]).to eq(false)
      expect(json[:data][:folders][:newFolder][:parentId]).to eq(@folder.id.to_s)
      expect(json[:data][:folders][:newFolder][:childFolders].empty?).to eq(true)
    end

    it 'returns parent folder' do
      post '/graphql', params: {query: query}
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:folders][:parentFolder][:name]).to eq("navani_base")
      expect(json[:data][:folders][:parentFolder][:base]).to eq(true)
      expect(json[:data][:folders][:parentFolder][:parentId]).to be(nil)
      expect(json[:data][:folders][:parentFolder][:childFolders]).to eq([{name: "Dalinar"}])
    end
  end

  def query
    <<~GQL
    mutation {
      folders: createFolder(
          userId: #{@user.id}
          parentId: #{@folder.id}
          name: "Dalinar"
        )
      {
        parentFolder {
          id
          name
          base
          parentId
          childFolders {
            name
          }
        }
        newFolder {
          id
          name
          base
          parentId
          childFolders {
            name
          }
        }
      }
    }
    GQL
  end
end
