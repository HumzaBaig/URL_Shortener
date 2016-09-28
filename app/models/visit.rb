class Visit < ActiveRecord::Base
  validates :visitor_id, presence: true
  validates :url_id, presence: true

  belongs_to :visitors,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: :User

  belongs_to :visited_urls,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl
end
