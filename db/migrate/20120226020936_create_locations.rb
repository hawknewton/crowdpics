class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, :options => 'ENGINE=MyISAM' do |t|
      t.column :latlon, :point, :null => false
      t.timestamps
    end

    change_table :locations do |t|
      t.index :latlon, :spatial => true
    end
  end
end
