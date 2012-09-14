class UsersController < ApplicationController
  # GET /users
  def index
    #db = GeoIP::City.new(RAILS_ROOT + '/GeoLiteCity.dat', :filesystem)

    @la = params[:la]
    @lo = params[:lo]
    if @la != nil and @lo != nil and @la =~ /[-+]?(?:\d*\.\d+|\d+)/ and @lo =~ /[-+]?(?:\d*\.\d+|\d+)/
      @users = User.find_by_sql("SELECT id,name, address, phone, aim, yim,  jabber, skype, latitude, longitude, md5(trim(lower(email))) as gravatar, ((2 * 3960 * ATAN2(SQRT(POWER(SIN((RADIANS(#{@la} - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(#{@la} )) * POWER(SIN((RADIANS(#{@lo} - longitude))/2), 2)),SQRT(1-(POWER(SIN((RADIANS(#{@la} - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(#{@la})) * POWER(SIN((RADIANS(#{@lo} - longitude))/2), 2)))))) AS distance FROM users where latitude is not null and longitude is not null ORDER BY distance LIMIT 40")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js  { render :json => @users }
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js  { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.js  { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.js  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.js  { head :ok }
      else
        format.js  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.js  { head :ok }
    end
  end
end
