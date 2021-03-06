require 'rails_helper'

RSpec.describe User, type: :model do 
  describe 'relationships' do
    it { should have_many(:folders) }
    it { should have_many(:resources).through(:folders) }
  end
end
