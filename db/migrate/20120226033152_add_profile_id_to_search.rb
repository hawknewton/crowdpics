class AddProfileIdToSearch < ActiveRecord::Migration
  def change
    add_column :tags, :profile_id, :integer
  end
end
