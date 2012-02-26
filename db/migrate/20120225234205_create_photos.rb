class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :profile_id
      t.string :hash
      t.float :lat
      t.float :long
      t.datetime :date_taken

      t.timestamps
    end
  end
end
