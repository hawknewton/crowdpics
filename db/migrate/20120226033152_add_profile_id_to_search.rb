class AddProfileIdToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :profile_id, :integer
  end
end
