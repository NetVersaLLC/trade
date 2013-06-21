require 'spec_helper'

describe UsersController do

  describe 'Authenticated users' do

    describe "GET 'index'" do
      it "should show users map" do
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
        get :index
        response.should be_success
      end
    end

    describe "GET 'show'" do

      it "should be successful" do
        get :show, :id => @user.id
        response.should be_success
      end

      it "should find the right user" do
        get :show, :id => @user.id
        assigns(:user).should == @user
      end

    end
  end
end
