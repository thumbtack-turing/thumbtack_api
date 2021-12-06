require 'rails_helper'

RSpec.describe FolderResource, type: :model do
  describe 'relationships' do
    it { should belong_to(:folder) }
    it { should belong_to(:resource) }
  end
end
