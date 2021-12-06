require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'folders query' do
    it 'can query a single folder' do
      user1 = User.create( name: "Rowan", email: "rowan@test.com")

      base_folder = user1.folders.create!(name: "Root", base: true)

      sub_folder1 = user1.folders.create!(name: "sub1", base: false, user_id: user1.id, parent_id: base_folder.id)
      sub_folder2 = Folder.create!(name: "sub2", base: false, parent_id: base_folder.id, user_id: user1.id)
      resource1 = base_folder.resources.create(name: "resource1", url: "123.com", image: "123.image")
      
      result = ThumbtackApiSchema.execute(query(base_folder.id)).as_json
      
      expect(result["data"]["getFolder"]["name"]).to eq("Root")
      expect(result["data"]["getFolder"]["base"]).to eq(true)
      expect(result["data"]["getFolder"]["id"]).to eq(base_folder.id.to_s)
      expect(result["data"]["getFolder"]["parentId"]).to eq(nil)

      expect(result["data"]["getFolder"]["childFolders"].count).to eq(2)
      expect(result["data"]["getFolder"]["childFolders"].first["id"]).to eq(sub_folder1.id.to_s)
      expect(result["data"]["getFolder"]["childFolders"].first["name"]).to eq('sub1')
      expect(result["data"]["getFolder"]["childFolders"].first["base"]).to eq(false)
      expect(result["data"]["getFolder"]["childFolders"].first["parentId"]).to eq(base_folder.id.to_s)

      expect(result["data"]["getFolder"]["childResources"].count).to eq(1)
      expect(result["data"]["getFolder"]["childResources"].first["id"]).to eq(resource1.id.to_s)
      expect(result["data"]["getFolder"]["childResources"].first["name"]).to eq('resource1')
      expect(result["data"]["getFolder"]["childResources"].first["url"]).to eq("123.com")
      expect(result["data"]["getFolder"]["childResources"].first["image"]).to eq("123.image")
    end
  end

  def query(id)
    <<~GQL
    {
      getFolder (id: "#{id}") {
        id
        name
        base
        parentId
        childFolders {
            id
            name
            base
            parentId
        }
        childResources {
            id
            name
            url
            image
            createdAt
        }
      }
    }
    GQL
  end
end