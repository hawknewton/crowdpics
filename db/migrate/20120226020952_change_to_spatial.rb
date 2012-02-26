class ChangeToSpatial < ActiveRecord::Migration
  def up
    change_table :photos do |t|
      t.remove :lat, :long
      t.integer :location_id
    end
  end

  def down
    change_table :photos do |t|
      t.float :lat
      t.float :long
      t.remove :location_id
    end
  end
end
