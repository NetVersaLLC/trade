require 'spec_helper'

describe UsersController do

  describe 'Authenticated users' do

    describe "GET 'index'" do
      it "should show users map" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        get :index
        response.should be_success
      end
    end

  end

  describe 'Authenticated users' do

    before (:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'index'" do
      it "should show users map" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        get :index
        response.should be_success
      end
    end
  end
end
