class CreateOmnisocialTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # Any additional fields here
      t.string :name
      t.string :address
      t.string :email
      t.string :phone
      t.string :aim
      t.string :msn
      t.string :jabber
      t.string :skype
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
    end
    add_index :authentications, :provider
    add_index :authentications, :uid
  end

  def self.down
    drop_table :users
    drop_table :authentications
  end
end
