require 'rails_helper'
RSpec.describe 'create resource', type: :request do
  describe 'resolve' do
    before :each do
        @user1 = User.create( name: "Rowan", email: "rowan@test.com")

        @base_folder = @user1.folders.create!(name: "Root", base: true)
  
        @sub_folder1 = Folder.create!(name: "sub1", base: false, user_id: @user1.id, parent_id: @base_folder.id)
        @sub_folder2 = Folder.create!(name: "sub2", base: false, parent_id: @base_folder.id, user_id: @user1.id)
        @resource1 = @base_folder.resources.create(name: "resource1", url: "123.com", image: "123.image")
    end

    it 'creates a new resource and folderResource' do
      post '/graphql', params: {query: query1}
      result = JSON.parse(response.body)

      expect(result['data']['createResource']['name']).to eq("Root")
      expect(result['data']['createResource']['id']).to eq(@base_folder.id.to_s)
      expect(result['data']['createResource']['base']).to eq(true)

      expect(result['data']['createResource']['childResources'].count).to eq(2)
      expect(result['data']['createResource']['childResources'][1]['name']).to eq("Some resource")
      expect(result['data']['createResource']['childResources'][1]['url']).to eq("www.stackoverflow.com")
      expect(result['data']['createResource']['childResources'][1]['image']).to be_a(String)
    end

    it 'uses placeholder image if none found' do
      post '/graphql', params: {query: query2}
      result = JSON.parse(response.body)

      expect(result['data']['createResource']['childResources'][0]['name']).to eq("Example")
      expect(result['data']['createResource']['childResources'][0]['url']).to eq("www.example.com")
      expect(result['data']['createResource']['childResources'][0]['image']).to eq("https://www.oiml.org/en/ressources/icons/link-icon.png/image_preview")
   
    end

    it 'throws an error given bad inputs' do
      post '/graphql', params: {query: query3}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:errors].count).to eq(1) 
      expect(result[:errors].first[:message]).to eq("Field 'createResource' is missing required arguments: url") 
    end

    it 'throws an error given bad parent folder id' do
      post '/graphql', params: {query: query4}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:errors].count).to eq(1) 
      expect(result[:errors].first[:message]).to eq("Folder must exist") 
    end
  end
end

def query1
  <<~GQL
    mutation {
      createResource(
        name: "Some resource"
        url: "www.stackoverflow.com"
        folderId: #{@base_folder.id}
      ){
        id
        name
        base
        parentId
        childResources {
            id
            name
            url
            image
        }
        }
      }
  GQL
end

def query2
  <<~GQL
    mutation {
      createResource(
        name: "Example"
        url: "www.example.com"
        folderId: #{@base_folder.id}
      ){
        id
        name
        base
        parentId
        childResources {
            id
            name
            url
            image
        }
        }
      }
  GQL
end

def query3
  <<~GQL
    mutation {
      createResource(
        name: "Example"
        
        folderId: #{@base_folder.id}
      ){
        id
        name
        base
        parentId
        childResources {
            id
        }
        }
      }
  GQL
end

def query4
  <<~GQL
    mutation {
      createResource(
        name: "Example"
        url: "example.com"
        folderId: #{@base_folder.id + 3}
      ){
        id
        name
        base
        parentId
        childResources {
            id
        }
        }
      }
  GQL
end