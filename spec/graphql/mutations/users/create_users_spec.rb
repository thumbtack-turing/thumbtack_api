require 'rails_helper'

RSpec.describe Types::MutationType do
  describe 'create users mutation' do
    it 'creates a user' do
      expect(User.count).to eq(0)
      result = ThumbtackApiSchema.execute(query).as_json
      expect(User.count).to eq(1)
      expect(result["data"]["createUser"]["name"]).to eq("Odell Stang")
      expect(result["data"]["createUser"]["email"]).to eq("odellthedog@test.com")
    end
  end

  def query
    <<~GQL
      mutation {
        createUser(
          name: "Odell Stang",
          email: "odellthedog@test.com"
        ) {
            name
            email
            baseFolder {
              id
              name
            }
          }
      }
    GQL
  end
end
