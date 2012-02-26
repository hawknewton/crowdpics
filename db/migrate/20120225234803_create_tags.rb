class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :facebook_profile_id
      t.integer :profile_id
      t.integer :photo_id

      t.timestamps
    end
  end
end
