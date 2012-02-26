class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :facebook_profile_id
      t.string :email
      t.string :facebook_oauth_token
      t.string :facebook_oauth_secret

      t.timestamps
    end
  end
end
