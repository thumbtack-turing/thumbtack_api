require 'rails_helper'

RSpec.describe Mutations::Folders::CreateFolder, type: :request do
  before(:each) do
    @user = User.create(name: 'Navani', email: 'storms@example.com')
    @folder = @user.folders.create(name: 'navani_base', base: true)
  end
  describe '.resolve' do
    it 'creates a folder' do
      expect(Folder.count).to eq(1)
      post '/graphql', params: {query: query1}
      expect(Folder.count).to eq(2)
    end

    it 'returns new folder' do
      post '/graphql', params: {query: query1}
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:folders][:newFolder][:name]).to eq("Dalinar")
      expect(json[:data][:folders][:newFolder][:base]).to eq(false)
      expect(json[:data][:folders][:newFolder][:parentId]).to eq(@folder.id.to_s)
      expect(json[:data][:folders][:newFolder][:childFolders].empty?).to eq(true)
    end

    it 'returns parent folder' do
      post '/graphql', params: {query: query1}
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:folders][:parentFolder][:name]).to eq("navani_base")
      expect(json[:data][:folders][:parentFolder][:base]).to eq(true)
      expect(json[:data][:folders][:parentFolder][:parentId]).to be(nil)
      expect(json[:data][:folders][:parentFolder][:childFolders]).to eq([{name: "Dalinar"}])
    end

    describe 'edge cases' do
      it 'returns error for missing arguments' do
        post '/graphql', params: {query: query2}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Field 'createFolder' is missing required arguments: parentId")

        post '/graphql', params: {query: query3}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Field 'createFolder' is missing required arguments: name")

        post '/graphql', params: {query: query4}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Field 'createFolder' is missing required arguments: userId")
      end

      it 'rescues from RecordNotFound' do
        post '/graphql', params: {query: query5}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:folders]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Invalid user or folder id.")

        post '/graphql', params: {query: query6}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:folders]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Invalid user or folder id.")
      end
    end
  end

  def query1
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

  def query2
    <<~GQL
    mutation {
      folders: createFolder(
          userId: #{@user.id}
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

  def query3
    <<~GQL
    mutation {
      folders: createFolder(
          userId: #{@user.id}
          parentId: #{@folder.id}
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

  def query4
    <<~GQL
    mutation {
      folders: createFolder(
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

  def query5
    <<~GQL
    mutation {
      folders: createFolder(
          userId: 425436543745724
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

  def query6
    <<~GQL
    mutation {
      folders: createFolder(
          userId: #{@user.id}
          parentId: 23498529374425
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
