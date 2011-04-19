class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username

      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.timestamps
      t.certifiable
    end
  end
  
  def self.down
    drop_table :users
  end
end
