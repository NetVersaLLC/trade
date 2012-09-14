require 'rubygems'
require 'net/http'
require 'xmlsimple'
require 'json'

def reverse_geocode(lat, lng)
	url = "http://maps.google.com/maps/geo?ll=#{lat.to_s},#{lng.to_s}&output=xml"
	uri = URI.parse(url)
	req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
	res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
	doc = XmlSimple.xml_in(res.body)
	response = doc['Response'].first
	if response['Status'].first['code'].first.to_i == 200
		placemark = response['Placemark'].first
		return placemark
	end
	return nil
end

namespace :count do
	task :countries => [:environment] do
		unknown = 0
		changed = 0
		nolatlon = 0
		User.all.each do |u|
			next if u.country != nil
			if u.latitude == nil or u.longitude == nil
				nolatlon += 1
				next
			end
			res = reverse_geocode(u.latitude, u.longitude)
			if res == nil
				unknown += 1
				next
			end
			File.open('/tmp/users/'+u.id.to_s, 'w') do |f|
				f.write JSON(res)
			end
			begin
				STDERR.puts res.inspect
				STDERR.puts u.inspect
				u.country =  res['AddressDetails'][0]['Country'][0]['CountryName'][0]
				STDERR.puts u.country
				u.save!
				changed += 1
			rescue Exception => e
				STDERR.puts e.to_s
				unknown += 1
			end
		end
		STDERR.puts "Changed: #{changed}"
		STDERR.puts "Uknown: #{unknown}"
		STDERR.puts "NoLatLon: #{nolatlon}"
	end
end

