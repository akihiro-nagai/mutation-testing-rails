require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'validations' do
    subject { build(:blog, status: status) }

    describe 'validate_status' do
      # memo: archived のテストが抜けているが、これは mutant で検出できない
      valid_statuses = %w[draft published]
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
    # memo: publish! では save! を呼び出すため、blog は create ではなく build で作らないと mutant に怒られる
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

  describe 'concerns' do
    describe '#short_content' do
      let(:blog) { create(:blog, content: 'This is a sample blog content.') }

      it 'returns the first 20 characters of content' do
        expect(blog.short_content).to eq('This is a sample ...')
      end

      it 'returns the full content if it is shorter than 30 characters' do
        short_blog = create(:blog, content: 'Short content.')
        expect(short_blog.short_content).to eq('Short content.')
      end

      it 'returns "[no content]" if content is an empty string' do
       blog = create(:blog, content: '')
       expect(blog.short_content).to eq('[no content]')
      end
    end
  end
end
