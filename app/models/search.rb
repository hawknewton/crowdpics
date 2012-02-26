class Search < ActiveRecord::Base
  attr_accessible :state, :tag, :latitude, :longitude, :date_time
  belongs_to :profile
end
