class AddDeactivatedFlagToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :deactivated, :boolean
  end

  def self.down
    remove_column :users, :deactivated
  end
end
