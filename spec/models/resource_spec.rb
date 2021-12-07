require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'relationships' do
    it { should belong_to(:folder) }
  end
end
