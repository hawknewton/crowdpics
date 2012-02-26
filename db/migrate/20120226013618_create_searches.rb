class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :facebook_uuid
      t.string :facebook_oauth_token

      t.timestamps
    end
  end
end
