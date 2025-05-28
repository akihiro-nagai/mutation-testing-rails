module ContentAvailable
  extend ActiveSupport::Concern

  included do
    # memo: mutant では concern の mutating はできない？
    def short_content
      return "[no content]" if content.blank?

      content.truncate(20, separator: " ")
    end
  end
end
