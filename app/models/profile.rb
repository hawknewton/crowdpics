class Profile < ActiveRecord::Base
  attr_accessible :facebook_profile_id, :email, :facebook_oauth_token, :facebook_oauth_secret

  validates :email, presence: true

  has_many :tags
end
