require 'rails_helper'

RSpec.describe Mutations::Users::DeleteUser, type: :request do
  before(:each) do
    @user1 = User.create(name: "Dalinar", email: "kaladinismyfav@example.com")
    @user1.folders.create(name: "dalinar_base", base: true)
    @user2 = User.create(name: "Sadeas", email: "shards.for.lyfe@example.com")
    @sad_base = @user2.folders.create(name: "sadeas_base", base: true)
    @sad_base.resources.create(name: "how to betray friends", url: "www.totalcrem.com/bridgemen-suck")
  end

  describe '.resolve' do
    it 'deletes a user by id' do
      expect(User.all.count).to eq(2)
      post '/graphql', params: {query: query}
      expect(User.all.count).to eq(1)
    end

    it 'returns deleted user name and id' do
      post '/graphql', params: {query: query}
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:deleteUser][:id]).to eq(@user2.id.to_s)
      expect(json[:data][:deleteUser][:name]).to eq(@user2.name)
    end

    it 'deletes user folders and resources' do
      expect(Folder.all.count).to eq(2)
      expect(Resource.all.count).to eq(1)
      post '/graphql', params: {query: query}
      expect(Folder.all.count).to eq(1)
      expect(Resource.all.count).to eq(0)
    end
  end

  def query
    <<~GQL
    mutation {
      deleteUser(id: #{@user2.id})
      {
        id
        name
      }
    }
    GQL
  end
end
