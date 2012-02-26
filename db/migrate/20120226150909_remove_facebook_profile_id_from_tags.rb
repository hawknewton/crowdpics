class RemoveFacebookProfileIdFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :facebook_profile_id
  end
end
