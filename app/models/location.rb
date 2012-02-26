class Location < ActiveRecord::Base

  has_many :photos

  # By default, use the GEOS implementation for spatial columns.
  self.rgeo_factory_generator = RGeo::Geos.method(:factory)

  # But use a geographic implementation for the :latlon column.
  set_rgeo_factory_for_column(:latlon, RGeo::Geographic.spherical_factory)

end
