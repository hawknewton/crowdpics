class Photo < ActiveRecord::Base
  validates :hash_tag, :name, :name, presence: true

  has_many :tags
  belongs_to :location

end
