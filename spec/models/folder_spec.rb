require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name('Folder').optional }
    it { should have_many(:resources) }
    it { should have_many(:folders).dependent(:destroy) }
  end

  describe 'instance methods' do
    it 'returns a file path as a string' do
      @user = User.create(name: 'Leslie Knope', email: 'pawnee@example.com')
      @base = @user.folders.create(name: 'Base', base: true)
      @folder1 = @user.folders.create(name: 'Waffles', parent_id: @base.id)
      @folder2 = @user.folders.create(name: 'Toppings', parent_id: @folder1.id)
      @folder3 = @user.folders.create(name: 'Syrup flavors', parent_id: @folder2.id)

      expect(@folder3.create_file_path("")).to eq('/Base/Waffles/Toppings/Syrup-flavors')
    end
  end
end
