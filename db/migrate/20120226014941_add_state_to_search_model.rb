class AddStateToSearchModel < ActiveRecord::Migration
  def change
    add_column :searches, :state, :string
  end
end
