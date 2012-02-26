class Search < ActiveRecord::Base
  attr_accessible :state, :tag, :latitude, :longitude, :date_time, :profile
  belongs_to :profile
end
