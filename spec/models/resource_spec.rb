require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'relationships' do
    it { should have_many(:folder_resources) }
    it { should have_many(:folders).through(:folder_resources) }
  end
end
