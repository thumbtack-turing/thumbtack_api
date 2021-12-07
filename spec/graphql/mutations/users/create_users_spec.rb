require 'rails_helper'

RSpec.describe Types::MutationType do
  describe 'create users mutation' do
    it 'creates a user' do
      expect(User.count).to eq(0)
      ThumbtackApiSchema.execute(query).as_json
      expect(User.count).to eq(1)
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
