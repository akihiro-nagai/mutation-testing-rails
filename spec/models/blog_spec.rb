require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'validations' do
    subject { build(:blog, status: status) }

    describe 'validate_status' do
      # memo: archived のテストが抜けているが、これは mutant で検出できない
      valid_statuses = %w[draft published]
      # 正しくは ↓
      # valid_statuses = %w[draft published archived]

      valid_statuses.each do |valid_status|
        context "when status is '#{valid_status}'" do
          let(:status) { valid_status }
          it { expect(subject).to be_valid }
        end
      end

      context 'invalid status' do
        let(:status) { 'invalid_status' }

        it { expect(subject).not_to be_valid }
        it do
          subject.valid?
          expect(subject.errors[:status]).to \
            include("must be one of: draft, published, archived")
        end
      end
    end
  end

  describe 'scopes' do
    describe '.published' do
      let!(:published_blog) { create(:blog, status: 'published') }
      let!(:draft_blog) { create(:blog, status: 'draft') }
      let!(:archived_blog) { create(:blog, status: 'archived') }

      it 'returns only published blogs' do
        expect(Blog.published).to include(published_blog)
        # memo: mutant で以下のテストが必要であることは指摘されない
        expect(Blog.published).not_to include(draft_blog, archived_blog)
      end
    end
  end

  describe '#publish!' do
    # memo: save! を呼び出すため、blog は create ではなく build で作らないと mutant に怒られる
    #       save! の有無をテストすることができなくなってしまうため
    let(:blog) { build(:blog, status: 'draft') }
    let(:now) { Time.current.change(usec: 0) }

    it 'changes the status to published and sets published_at' do
      travel_to(now) do
        expect { blog.publish! }.to change { blog.status }.from('draft').to('published')
        expect(blog.published_at).to eq(now)
      end
    end

    it 'saves the blog' do
      expect { blog.publish! }.to change { blog.persisted? }.from(false).to(true)
    end
  end
end
