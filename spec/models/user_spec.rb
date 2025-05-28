require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
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

    describe '#is_admin?' do
      it 'returns true if the user is an admin' do
        subject.admin = true
        expect(subject.is_admin?).to be true
      end

      it 'returns false if the user is not an admin' do
        subject.admin = false
        expect(subject.is_admin?).to be false
      end

      context 'when username is admin' do
        it 'returns true' do
          subject.username = 'admin'
          expect(subject.is_admin?).to be true
        end
      end
    end
  end

  describe '#published_blogs' do
    let(:user) { create(:user) }
    let!(:published_blog) { create(:blog, user: user, status: 'published') }
    let!(:draft_blog) { create(:blog, user: user, status: 'draft') }

    subject { user.published_blogs }

    it 'returns only published blogs' do
      # memo: mutant で両方必要であることを指摘してくれる
      expect(subject).to include(published_blog)
      expect(subject).not_to include(draft_blog)
    end
  end
end
