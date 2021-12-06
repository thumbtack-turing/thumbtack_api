require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name('Folder').optional }
    it { should have_many(:folder_resources) }
    it { should have_many(:resources).through(:folder_resources) }
    it { should have_many(:folders) }
  end
end
