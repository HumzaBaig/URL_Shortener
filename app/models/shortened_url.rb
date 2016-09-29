class ShortenedUrl < ActiveRecord::Base
  validates :long_url, presence: true
  validates :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitors

  def self.random_code
    exists = true
    code = ""
    while exists
      code = SecureRandom.urlsafe_base64
      exists = false unless ShortenedUrl.exists?(:short_url => code)
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!({long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id})
  end

  # def num_clicks
  #   #slower
  #   # arr = Visit.all.select{ |visit| visit.url_id == self.id }
  #   # arr.count
  #   # self.visits.count
  #   Visit.select(:visitor_id).where(url_id: self.id).count
  # end

  def num_uniques
    Visit.select(:visitor_id).where(url_id: self.id).count
  end

  def num_recent_uniques
    Visit.select(:visitor_id).where('url_id = ? AND created_at > ?', self.id, 10.minutes.ago).distinct.count
  end
end
