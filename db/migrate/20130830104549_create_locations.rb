class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :short_name
      t.string :location_type
      t.integer :parent_location_id
    end
    add_index :locations, :parent_location_id

    create_table :users_locations do |t|
      t.integer :user_id
      t.integer :location_id
    end
    add_index :users_locations, [:user_id, :location_id]
  end
end
