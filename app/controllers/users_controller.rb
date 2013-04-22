class UsersController < ApplicationController
  before_filter :check_user, only: [:edit, :update]

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

  def edit
  end

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

  def update
    respond_to do |format|
      if @user.update_attributes(permitted_params)
        format.js  { head :ok }
        format.html do 
          flash[:notice] = "You updated your account successfully."
          redirect_to :back
        end
      else
        format.js  { render :json => @user.errors, :status => :unprocessable_entity }
        format.html do 
          flash[:error] = "There were errors during profile updating"
          redirect_to :back
        end
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.js  { head :ok }
    end
  end

  private 
  def permitted_params
    if User.find(params[:id]) == current_user
      params.require(:user).permit(:name, :email, :current_password, :address, :phone, :skype, :aim, :yim, :jabber)
    end
  end

  def check_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end
end
