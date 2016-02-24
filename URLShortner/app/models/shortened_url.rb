class ShortenedURL < ActiveRecord::Base
  validates :long_url, presence: true
  validates :short_url, :submitter_id, presence: true, uniqueness: true

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while self.exists?(:short_url => code)
      code = SecureRandom.urlsafe_base64
    end

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    code = self.random_code

    ShortenedURL.create!(submitter_id: user.id, long_url: long_url, short_url: code)
  end

end
