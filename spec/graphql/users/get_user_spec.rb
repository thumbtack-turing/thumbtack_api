require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'users query' do
    it 'can query a single user' do
      user1 = User.create( name: "Rowan", email: "rowan@test.com")
      user2 = User.create( name: "Erika", email: "erika@test.com")
      user3 = User.create( name: "Jamie", email: "jamie@test.com")
      
      result = ThumbtackApiSchema.execute(query).as_json
      expect(result["data"]["getUser"]["name"]).to eq("Rowan")
      expect(result["data"]["getUser"]["email"]).to eq("rowan@test.com")
      expect(result["data"]["getUser"]["id"]).to eq(user1.id.to_s)
    end
  end

  def query
    <<~GQL
    {
      getUser(email: "rowan@test.com") {
        name
        email
        id
      }
    }
    GQL
  end
end