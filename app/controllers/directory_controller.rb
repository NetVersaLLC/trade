class DirectoryController < ApplicationController
  # users directory

  def location
    id = params[:id]
    @locations = Location.where(:parent_location_id => id)
    unless id  == 0
      @users = Location.find(id).users.where("LENGTH(name) > 1").paginate(:page => params[:page])
    end

    begin
      @location = Location.find(id)
      @title = "#{@location.name} Bitcoin Traders - Tradebitcoin.com"
    rescue
      @location = Location.new(:name => "")
    end
  end

end
