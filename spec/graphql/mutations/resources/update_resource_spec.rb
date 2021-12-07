require 'rails_helper'

RSpec.describe 'update resource' do
  describe 'describe resolve' do
    before :each do
      @user1 = User.create( name: "Odell the dog", email: "odie@moretreats.com")

      @base_folder = @user1.folders.create!(name: "Base", base: true)

      @sub_folder1 = Folder.create!(name: "sub1", base: false, user_id: @user1.id, parent_id: @base_folder.id)
      @sub_folder2 = Folder.create!(name: "sub2", base: false, parent_id: @base_folder.id, user_id: @user1.id)
      @resource1 = Resource.create!(name: "resource1", url: "123.com", image: "123.image")
      @folder_resource = FolderResource.create!(resource_id: @resource1.id, folder_id: @base_folder.id)

    end

    it 'can update a resource name' do
      query = <<~GQL
      mutation {
        updateResource (
          id: #{@resource1.id},
          folderId: #{@base_folder.id}
          name: "New name",
          ) {
            id
            name
            folders {
              id
              name
            }
          }
        }
        GQL

      result = ThumbtackApiSchema.execute(query).as_json

      expect(result["data"]["updateResource"]["name"]).to eq("New name")
      expect(result["data"]["updateResource"]["folders"].first["id"]).to eq("#{@base_folder.id}")
    end

    it 'can update the folder for a resource' do
      query = <<~GQL
      mutation {
        updateResource (
          id: #{@resource1.id},
          folderId: #{@base_folder.id}
          newFolderId: #{@sub_folder1.id},
          ) {
            id
            name
            folders {
              id
              name
            }
          }
        }
        GQL

        result = ThumbtackApiSchema.execute(query).as_json

        expect(result["data"]["updateResource"]["name"]).to eq("#{@resource1.name}")
        expect(result["data"]["updateResource"]["folders"].first["id"]).to eq("#{@sub_folder1.id}")
    end
  end
end
