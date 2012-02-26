class Photo < ActiveRecord::Base
  validates :hash, :path, presence: true

  has_many :tags
end
