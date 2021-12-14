require 'rails_helper'

RSpec.describe 'update resource', type: :request do
  describe 'describe resolve' do
    before :each do
      @user1 = User.create( name: "Odell the dog", email: "odie@moretreats.com")

      @base_folder = @user1.folders.create!(name: "Base", base: true)

      @sub_folder1 = Folder.create!(name: "sub1", base: false, user_id: @user1.id, parent_id: @base_folder.id)
      @sub_folder2 = Folder.create!(name: "sub2", base: false, parent_id: @base_folder.id, user_id: @user1.id)
      @resource1 = @base_folder.resources.create!(name: "resource1", url: "123.com", image: "123.image")

    end

    it 'can update a resource name' do
      query = <<~GQL
      mutation {
        updateResource (
          id: #{@resource1.id},
          folderId: #{@base_folder.id}
          name: "New name",
          ) {
            updatedResource {
              id
              name
              folder {
                id
                name
            }}
            originalParent {
              id
              name
            }
          }
        }
        GQL

      result = ThumbtackApiSchema.execute(query).as_json

      expect(result["data"]["updateResource"]["updatedResource"]["name"]).to eq("New name")
      expect(result["data"]["updateResource"]["updatedResource"]["folder"]["id"]).to eq("#{@base_folder.id}")
      expect(result["data"]["updateResource"]["originalParent"]["id"]).to eq(@base_folder.id.to_s)
      expect(result["data"]["updateResource"]["originalParent"]["name"]).to eq(@base_folder.name)
    end

    it 'can update the folder for a resource' do
      query = <<~GQL
      mutation {
        updateResource (
          id: #{@resource1.id},
          folderId: #{@base_folder.id}
          newFolderId: #{@sub_folder1.id},
          ) {
            updatedResource {
            id
            name
            folder {
              id
              name
          }}
          originalParent {
            id
            name
          }
        }
        }
        GQL

        result = ThumbtackApiSchema.execute(query).as_json

        expect(result["data"]["updateResource"]["updatedResource"]["name"]).to eq("#{@resource1.name}")
        expect(result["data"]["updateResource"]["updatedResource"]["folder"]["id"]).to eq("#{@sub_folder1.id}")
        expect(result["data"]["updateResource"]["originalParent"]["id"]).to eq(@base_folder.id.to_s)
        expect(result["data"]["updateResource"]["originalParent"]["name"]).to eq(@base_folder.name)
    end

    it 'throws an error given bad ids' do
      query = <<~GQL
        mutation {
          updateResource (
            id: #{@resource1.id + 1},
            folderId: #{@base_folder.id}
            newFolderId: #{@sub_folder1.id},
            ) {
              updatedResource {
              id
              name
              folder {
                id
                name
            }}
            originalParent {
              id
              name
            }
          }
        }
        GQL

      post '/graphql', params: {query: query}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:errors].count).to eq(1) 
      expect(result[:errors].first[:message]).to eq("Invalid resource or folder id.") 
    end

    it 'throws an error given missing arguments' do
      query = <<~GQL
        mutation {
          updateResource (
            id: #{@resource1.id + 1}
            newFolderId: #{@sub_folder1.id}
            ) {
              updatedResource {
              id
              name
              folder {
                id
                name
            }}
            originalParent {
              id
              name
            }
          }
        }
        GQL

      post '/graphql', params: {query: query}
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:errors].count).to eq(1) 
      expect(result[:errors].first[:message]).to eq( "Field 'updateResource' is missing required arguments: folderId") 
    end
  end
end
