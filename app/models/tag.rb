class Tag < ActiveRecord::Base
  validates :photo_id, :facebook_profile_id, presence: true
end
