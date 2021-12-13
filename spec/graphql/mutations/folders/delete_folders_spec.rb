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

      post '/graphql', params: {query: query1}

      expect(Folder.last).to_not eq(@folder2)
      expect(Resource.last).to_not eq(@resource)
    end

    it 'returns data for the parent folder' do
      post '/graphql', params: {query: query1}

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data]

      expect(data[:deleteFolder][:id]).to eq(@base.id.to_s)
      expect(data[:deleteFolder][:name]).to eq(@base.name)
    end

    describe 'edge cases' do
      it 'rescues folder not found with error' do
        post '/graphql', params: {query: query2}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data[:deleteFolder]).to eq(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Invalid folder id.")
      end

      it 'rescues non-integer id with error' do
        post '/graphql', params: {query: query3}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data[:deleteFolder]).to eq(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Invalid folder id.")
      end

      it 'returns error without id argument' do
        post '/graphql', params: {query: query4}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Field 'deleteFolder' is missing required arguments: id")
      end
    end
  end

  def query1
    <<~GQL
    mutation {
      deleteFolder(id: #{@folder2.id}) {
        id
        name
      }
    }
    GQL
  end

  def query2
    <<~GQL
    mutation {
      deleteFolder(id: 999999999999) {
        id
        name
      }
    }
    GQL
  end

  def query3
    <<~GQL
    mutation {
      deleteFolder(id: "this should be an id.") {
        id
        name
      }
    }
    GQL
  end

  def query4
    <<~GQL
    mutation {
      deleteFolder {
        id
        name
      }
    }
    GQL
  end
end
