class UsersController < Devise::RegistrationsController

  # GET /users
  def index
    #db = GeoIP::City.new(RAILS_ROOT + '/GeoLiteCity.dat', :filesystem)

    @la = params[:la]
    @lo = params[:lo]
    if @la != nil and @lo != nil and @la =~ /[-+]?(?:\d*\.\d+|\d+)/ and @lo =~ /[-+]?(?:\d*\.\d+|\d+)/
      @users = User.find_by_sql([<<SQL, {:la => @la, :lo => @lo}])
SELECT
  id, name, address, phone, aim, yim,  jabber, skype, latitude, longitude,
  md5(trim(lower(email))) as gravatar,
  ((2 * 3960 * ATAN2(SQRT(POWER(SIN((RADIANS(:la - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(:la)) *
  POWER(SIN((RADIANS(:lo - longitude))/2), 2)),SQRT(1-(POWER(SIN((RADIANS(:la - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(:la)) * POWER(SIN((RADIANS(:lo - longitude))/2), 2)))))) AS distance
FROM users
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
ORDER BY distance
LIMIT 40
SQL
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js  { render :json => @users }
    end
  end

end
