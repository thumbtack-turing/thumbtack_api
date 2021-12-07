require 'rails_helper'
RSpec.describe 'create resource', type: :request do
  describe 'resolve', :vcr do
    before :each do
        @user1 = User.create( name: "Rowan", email: "rowan@test.com")

        @base_folder = @user1.folders.create!(name: "Root", base: true)
  
        @sub_folder1 = Folder.create!(name: "sub1", base: false, user_id: @user1.id, parent_id: @base_folder.id)
        @sub_folder2 = Folder.create!(name: "sub2", base: false, parent_id: @base_folder.id, user_id: @user1.id)
        @resource1 = @base_folder.resources.create(name: "resource1", url: "123.com", image: "123.image")
      

      @query = <<~GQL
                mutation {
                  createResource(
                    input: {
                      name: "Some resource"
                      url: "www.stackoverflow.com"
                      folderId: #{@base_folder.id}
                    }
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

    it 'creates a new resource and folderResource' do
      post '/graphql', params: {query: @query}
      result = JSON.parse(response.body)
 
      expect(result['data']['createResource']['name']).to eq("Root")
      expect(result['data']['createResource']['id']).to eq(@base_folder.id.to_s)
      expect(result['data']['createResource']['base']).to eq(true)

      expect(result['data']['createResource']['childResources'].count).to eq(2)
      expect(result['data']['createResource']['childResources'][1]['name']).to eq("Some resource")
      expect(result['data']['createResource']['childResources'][1]['url']).to eq("www.stackoverflow.com")
      expect(result['data']['createResource']['childResources'][1]['image']).to be_a(String)
    end
  end
end