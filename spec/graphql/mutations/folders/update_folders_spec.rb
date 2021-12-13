require 'rails_helper'

RSpec.describe Mutations::Folders::CreateFolder, type: :request do
  before(:each) do
    @user = User.create(name: 'Navani', email: 'storms@example.com')
    @base = @user.folders.create(name: 'navani_base', base: true)
    @folder1 = @user.folders.create(name: 'Dalinar', parent_id: @base.id)
    @folder2 = @user.folders.create(name: 'Honor', parent_id: @base.id)
  end

  describe '.resolve' do
    it 'updates a folder name' do
      post '/graphql', params: {query: query1}
      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data][:folders]

      expect(data[:updatedFolder][:id]).to eq(@folder1.id.to_s)
      expect(data[:updatedFolder][:name]).to eq("Husband")
      expect(data[:updatedFolder][:base]).to eq(false)
      expect(data[:updatedFolder][:parentId]).to eq(@base.id.to_s)

      expect(data[:originalParent][:id]).to eq(@base.id.to_s)
      expect(data[:originalParent][:name]).to eq(@base.name)
      expect(data[:originalParent][:base]).to eq(true)
      expect(data[:originalParent][:childFolders].count).to eq(2)
    end

    it 'updates a folder parent' do
      post '/graphql', params: {query: query2}
      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data][:folders]

      expect(data[:updatedFolder][:id]).to eq(@folder2.id.to_s)
      expect(data[:updatedFolder][:name]).to eq("Honor")
      expect(data[:updatedFolder][:base]).to eq(false)
      expect(data[:updatedFolder][:parentId]).to eq(@folder1.id.to_s)

      expect(data[:originalParent][:id]).to eq(@base.id.to_s)
      expect(data[:originalParent][:name]).to eq(@base.name)
      expect(data[:originalParent][:base]).to eq(true)
      expect(data[:originalParent][:childFolders].count).to eq(1)
      data[:originalParent][:childFolders].each do |child|
        expect(child[:id]).to_not eq(@folder2.id.to_s)
        expect(child[:name]).to_not eq("Honor")
      end
    end

    it 'updates both name and parent' do
      post '/graphql', params: {query: query3}
      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data][:folders]

      expect(data[:updatedFolder][:id]).to eq(@folder2.id.to_s)
      expect(data[:updatedFolder][:name]).to eq("Honor is dead.")
      expect(data[:updatedFolder][:base]).to eq(false)
      expect(data[:updatedFolder][:parentId]).to eq(@folder1.id.to_s)

      expect(data[:originalParent][:id]).to eq(@base.id.to_s)
      expect(data[:originalParent][:name]).to eq(@base.name)
      expect(data[:originalParent][:base]).to eq(true)
      expect(data[:originalParent][:childFolders].count).to eq(1)
      data[:originalParent][:childFolders].each do |child|
        expect(child[:id]).to_not eq(@folder2.id.to_s)
        expect(child[:name]).to_not eq("Honor is dead.")
        expect(child[:name]).to_not eq("Honor")
      end
    end

    describe 'edge cases' do
      it 'requires name or parent id argument' do
        post '/graphql', params: {query: query4}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:folders]

        expect(data).to be(nil)
        expect(json[:errors].first[:message]).to eq("Name or new parent id required.")
      end

      it 'rescues folder not found with error' do
        post '/graphql', params: {query: query5}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:folders]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Invalid folder id.")
      end

      it 'rescues from non-integer id with error' do
        post '/graphql', params: {query: query6}
        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:folders]

        expect(data).to be(nil)
        expect(json[:errors].count).to eq(1)
        expect(json[:errors].first[:message]).to eq("Invalid folder id.")
      end
    end
  end

  def query1
    <<~GQL
    mutation {
      folders: updateFolder (
        id: #{@folder1.id}
        name: "Husband")
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
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
      folders: updateFolder (
        id: #{@folder2.id}
        newParentId: #{@folder1.id})
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
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
      folders: updateFolder (
        id: #{@folder2.id}
        newParentId: #{@folder1.id}
        name: "Honor is dead.")
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
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
      folders: updateFolder (
        id: #{@folder2.id})
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
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
      folders: updateFolder (
        id: 999999999999
        name: "Husband")
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
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
      folders: updateFolder (
        id: "this is not an id"
        name: "Husband")
        {
        updatedFolder {
          id
          name
          base
          parentId
        }
        originalParent {
          id
          name
          base
          childFolders {
            id
            name
          }
        }
      }
    }
    GQL
  end
end
