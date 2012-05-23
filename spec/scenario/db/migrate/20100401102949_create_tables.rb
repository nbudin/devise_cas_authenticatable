class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.datetime :remember_created_at
      t.string :email
      t.timestamps
    end

    add_index :users, :username, :unique => true
  end

  def self.down
    drop_table :users
  end
end
