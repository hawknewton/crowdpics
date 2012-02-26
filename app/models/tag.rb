class Tag < ActiveRecord::Base
  validates :photo_id, :facebook_profile_id, presence: true

  belongs_to :photo
  belongs_to :profile
end
