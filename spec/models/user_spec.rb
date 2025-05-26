require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:blogs).dependent(:destroy) }
  end

  describe 'validations' do
   it { is_expected.to validate_presence_of(:username) }
   it { is_expected.to validate_presence_of(:email) }
   it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'database columns' do
   it { is_expected.to have_db_column(:username).of_type(:string) }
   it { is_expected.to have_db_column(:email).of_type(:string) }
  end
end
