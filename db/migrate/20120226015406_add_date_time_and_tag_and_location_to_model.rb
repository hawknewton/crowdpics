class AddDateTimeAndTagAndLocationToModel < ActiveRecord::Migration
  def change
    add_column :searches, :date_time, :integer
    add_column :searches, :tag, :string
    add_column :searches, :latitude, :decimal
    add_column :searches, :longitude, :decimal
  end
end
