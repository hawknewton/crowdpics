class Tag < ActiveRecord::Base
  attr_accessible :photo, :profile

  belongs_to :photo
  belongs_to :profile
end
