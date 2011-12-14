class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.bushido_authenticatable
      t.string :username
      t.rememberable
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
