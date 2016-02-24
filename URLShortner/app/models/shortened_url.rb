class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :submitter_id, presence: true
  validates :short_url, presence: true, uniqueness: true

  belongs_to(
    :submitter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :submitter_id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    primary_key: :id,
    foreign_key: :short_url_id
  )

  has_many(
    :visitors,
    through: :visits,
    source: :visitor
  )

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while self.exists?(:short_url => code)
      code = SecureRandom.urlsafe_base64
    end

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    code = self.random_code

    ShortenedUrl.create!(submitter_id: user.id, long_url: long_url, short_url: code)
  end

  def num_clicks
    self.visits.select(:visitor_id).count
  end

  def num_uniques
    self.visits.select(:visitor_id).distinct.count
  end

  def num_recent_uniques(time_ago = 10)
    self.visits.select(:visitor_id).distinct.where({ created_at: (Time.now - time_ago.minutes)..Time.now }).count
  end

end
