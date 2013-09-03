require 'net/http'
require 'open-uri'
require 'json'

class User < ActiveRecord::Base
  blogs

  after_create :update_locations

  self.per_page = 20

  # GEOCODING SETTINGS:
  # address components, that used to structure users directory
  @@directory_components = [:neighborhood, :sublocality, :locality, :postal_town, :administrative_area_level_2,
    :administrative_area_level_1, :country]
  # geographic object types to try when geocoding
  @@known_object_types = [:street_address, :locality, :route]

  attr_accessor :current_password

  has_many :users_locations
  has_many :locations, through: :users_locations


  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable #, :validatable
  validates :email, uniqueness: true, presence: true, 
                    format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }, if: :email_required?

  validates :password, :presence => true, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_length_of :password, :within => 6..40, :if => :password_required?

  #validate :current_password_should_match, if: :need_password_confirmation? # checked by devise

  def self.from_omniauth(auth_data)
    auth = Authentication.where(auth_data.slice(:provider, :uid)).first_or_create! do |authentication|
      authentication.provider = auth_data.provider
      authentication.uid = auth_data.uid
      user = User.new(name: auth_data.info.name)
      user.save(validate: false)
      authentication.user = user
    end
    auth.user
  end

  def email_required?
     (authentications.empty? || !password.blank?)
  end

  def password_required?
    (authentications.empty? || !password.blank?) && (!persisted? || !self.password.nil? || !password_confirmation.nil?)
  end

  def current_password_required?
    authentications.empty? || !password.blank?
  end

  def update_with_password(params, *options)
    if !current_password_required?
        update_attributes(params, *options)
    else
      super
    end
  end

  def gravatar
    Digest::MD5.hexdigest(email.downcase.strip)
  end

  def geocode_locations
    unless address.strip.length > 5
      raise "address is not set"
    end
    geocoder_results = query_geocoder # reverse geocoding query happens here
    geo_object = find_known_geo_object(geocoder_results)
    used_components = []
    @@directory_components.each do |component|
      # looking for a known address components in geocoder results
      result = find_component_by_type(component, geo_object['address_components'])
      if result
        used_components << result
      end
    end
    unless used_components.length > 2
      raise "address is not specific enough"
    end
    # replaces each component with corresponding db object, creating new if necessary
    # please notice that we are creating database users_locations records here
    self.locations = convert_components_to_locations(used_components)
  end

  def update_locations
    UsersLocation.where(:user_id => id).destroy_all
    begin
      geocode_locations
    rescue
    end
  end

  protected

  def find_known_geo_object(geocoder_results)
    @@known_object_types.each do |type|
      object = find_component_by_type(type, geocoder_results)
      if object
        return object
      end
    end
    raise "no known geo object found"
  end

  def convert_components_to_locations(components)
    results = []
    while component = components.pop do
      parent_id = results.empty? ? 0 : results.last.id
      if results.last and component['long_name'] == results.last.name
        next # ignoring sublocations with identical names
      end
      location = Location.where(:parent_location_id => parent_id,
                                :name => component['long_name'],
                                :short_name => component['short_name'],
                                :location_type => component['types'].first).first_or_create
      results << location
    end
    results
  end

  def query_geocoder
    response = Net::HTTP.get('maps.googleapis.com', "/maps/api/geocode/json?address=#{URI::encode(address)}&sensor=false")
    #response = Net::HTTP.get('maps.googleapis.com', "/maps/api/geocode/json?latlng=#{latitude},#{longitude}&sensor=false")
    data = JSON.parse response
    unless data['status'] = 'OK'
      puts response
      raise "geocoding request failed"
    end
    data['results']
  end

  def find_component_by_type(type, components)
    components.each do |component|
      next unless component['types'].include?(type.to_s)
      return component
    end
    false
  end


  private

  def need_password_confirmation?
    password_required? && !new_record?
  end

  def current_password_should_match
     errors.add(:current_password, "doesn't match") if !valid_password?(self.current_password)
  end

end
