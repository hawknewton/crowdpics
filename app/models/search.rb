class Search < ActiveRecord::Base
  attr_accessible :facebook_uuid, :facebook_oauth_token, :state, :tag, :latitude, :longitude, :date_time
end
