require 'rails_helper'

RSpec.describe Mutations::Folders::CreateFolder, type: :request do
  before(:each) do
    @user = User.create(name: 'Navani', email: 'storms@example.com')
    @base = @user.folders.create(name: 'navani_base', base: true)
    @folder1 = @user.folders.create(name: 'Dalinar', parent_id: @base.id)
    @folder2 = @user.folders.create(name: 'Honor', parent_id: @base.id)
    @resource = @folder2.resources.create(url: 'example.com', image: 'example.com/image', name: 'Example resource')
  end

  describe '.resolve' do
    it 'deletes a folder and its resources' do
      expect(Folder.last).to eq(@folder2)
      expect(Resource.last).to eq(@resource)

      post '/graphql', params: {query: query}

      expect(Folder.last).to_not eq(@folder2)
      expect(Resource.last).to_not eq(@resource)
    end

    it 'returns data for the deleted folder' do
      post '/graphql', params: {query: query}

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data]

      expect(data[:deleteFolder][:id]).to eq(@folder2.id.to_s)
      expect(data[:deleteFolder][:name]).to eq(@folder2.name)
    end
  end

  def query
    <<~GQL
    mutation {
      deleteFolder(id: #{@folder2.id}) {
        id
        name
      }
    }
    GQL
  end
end
