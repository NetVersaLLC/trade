require 'net/http'
require 'json'

namespace :geocode do

  desc "Create and assign locations using addresses"
  task :geocode_locations => :environment do
    users = User.find_by_sql("SELECT * FROM users WHERE LENGTH(address) > 0")
    users.each do |user|
      if user.locations.length == 0
        begin
          user.geocode_locations
          puts "Geocode successful for user #{user.id}"
        rescue
          puts "Geocode failed for user #{user.id}"
          next
        end
      end
    end
  end

end