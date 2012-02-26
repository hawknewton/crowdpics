class Profile < ActiveRecord::Base
  validates :email, presence: true

  has_many :tags
end
