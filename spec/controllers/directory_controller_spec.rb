require 'spec_helper'

describe DirectoryController do

  it "should show users map" do
    location = FactoryGirl.create(:location)
    get :location, :id => location.id
    response.should be_success
  end

end
