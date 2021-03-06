require 'rails_helper'
RSpec.describe 'delete resource', type: :request do
  describe 'resolve' do
    before :each do
        @user1 = User.create( name: "Rowan", email: "rowan@test.com")
        @base_folder = @user1.folders.create!(name: "Root", base: true)
        @resource1 = @base_folder.resources.create(name: "resource1", url: "123.com", image: "123.image")
      

      @query = <<~GQL
          mutation {
            deleteResource(
                id: #{@resource1.id}
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
      @query2 = <<~GQL
        mutation {
          deleteResource(
              id: 123456
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
      @query3 = <<~GQL
        mutation {
          deleteResource{
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

    it 'deletes a resource' do
      expect(Resource.count).to eq(1)
      post '/graphql', params: {query: @query}
      result = JSON.parse(response.body)
      expect(Resource.count).to eq(0)

      expect(result['data']['deleteResource']['name']).to eq("Root")
      expect(result['data']['deleteResource']['id']).to eq(@base_folder.id.to_s)
      expect(result['data']['deleteResource']['base']).to eq(true)

      expect(result['data']['deleteResource']['childResources']).to eq([])
    end

    it 'throws an error given bad id' do
      post '/graphql', params: {query: @query2}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:errors].count).to eq(1) 
      expect(result[:errors].first[:message]).to eq("Invalid resource id.") 
    end

    it 'throws an error given no id' do
       post '/graphql', params: {query: @query3}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:errors].count).to eq(1) 
      expect(result[:errors].first[:message]).to eq("Field 'deleteResource' is missing required arguments: id") 
    end

  end
end
