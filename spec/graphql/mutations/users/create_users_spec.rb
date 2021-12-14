require 'rails_helper'

RSpec.describe 'create user' do
  describe 'describe resolve' do
    it 'creates a new user and returns it' do
      expect(User.count).to eq(0)

      result = ThumbtackApiSchema.execute(query).as_json

      expect(User.count).to eq(1)
      expect(result["data"]["createUser"]["name"]).to eq("Odell Stang")
      expect(result["data"]["createUser"]["email"]).to eq("odellthedog@test.com")
    end
  end

  describe 'edge cases' do
    it 'returns an error if no name argument is given' do
      result = ThumbtackApiSchema.execute(query2).as_json

      expect(result["errors"]).to be_an(Array)
      expect(result["errors"].first).to be_a(Hash)
      expect(result["errors"].first).to have_key("message")
    end

    it 'returns an error if no email argument is given' do
      result = ThumbtackApiSchema.execute(query3).as_json

      expect(result["errors"]).to be_an(Array)
      expect(result["errors"].first).to be_a(Hash)
      expect(result["errors"].first).to have_key("message")
    end

    it 'returns an error if neither a name or an email is given' do
      result = ThumbtackApiSchema.execute(query4).as_json
    
      expect(result["errors"]).to be_an(Array)
      expect(result["errors"].first).to be_a(Hash)
      expect(result["errors"].first).to have_key("message")
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

  def query2
    <<~GQL
      mutation {
        createUser(
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

  def query3
    <<~GQL
      mutation {
        createUser(
          name: "Odell the Dog"
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

  def query4
    <<~GQL
      mutation {
        createUser {
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
