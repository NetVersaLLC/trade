class Addyahoo < ActiveRecord::Migration
  def self.up
    remove_column :users, :msn
    add_column :users, :yim, :string
    add_column :users, :show_email, :boolean, :default => false
  end

  def self.down
    remove_column :users, :show_email
    remove_column :users, :yim
    add_column :users, :msn, :string
  end
end
