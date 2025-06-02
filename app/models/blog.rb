class Blog < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy

  # concern テスト
  # include ContentAvailable

  # custom validator のテスト
  validate :validate_status
  VALID_STATUSES = %w[draft published archived]

  # scope のテスト
  scope :published, -> { where(status: "published") }

  def publish!
    self.status = "published"
    self.published_at = Time.current
    save!
  end

  def short_content
    return "[no content]" if content.blank?

    # 文字数のバリエーションを増やしても意味はないので
    # mutant:disable  <= 効かない。メソッドレベルでしか制御できないようだ
    content.truncate(20, separator: " ")
  end

  private

  def validate_status
    # mutant: 意味のない条件分岐を追加すると検出してくれる
    # unless VALID_STATUSES.include?(status) || status.nil?
    unless VALID_STATUSES.include?(status)
      # join() の中のバリエーションを増やしても意味はないので
      # mutant:disable  <= 効かない。メソッドレベルでしか制御できないようだ
      errors.add(:status, "must be one of: #{VALID_STATUSES.join(', ')}")
    end
  end
end
