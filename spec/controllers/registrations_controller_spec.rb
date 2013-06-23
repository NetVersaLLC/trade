require 'spec_helper'


describe RegistrationsController do

  describe 'Authenticated users' do

    before (:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'edit'" do

      it "should be successful" do
        get :update
        response.should be_success
      end

      #it "should find the right user" do
      #  get :edit, :id => @user.id
      #  assigns(:user).should == @user
      #end

    end

  end
end