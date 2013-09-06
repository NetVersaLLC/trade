### GIVEN ###
Given /^Directory contains my location$/ do
  @location = FactoryGirl.create(:location)
end

Given /^My location has traders$/ do
  @user = FactoryGirl.create(:user)
  @users_location = UsersLocation.create({:location_id => @location.id, :user_id => @user.id})
end


### WHEN ###

When /^I open directory index$/ do
  visit '/browse'
end

When /^I open location page$/ do
  visit '/browse/' + @location.id.to_s
end

### THEN ###
Then /^I should see my location in the list$/ do
  page.should have_content @location.name
end

Then /^I should see a list of traders$/ do
  page.should have_content @user.name
end

Then /^I should see location name as header$/ do
  page.html.should include("<h1 class='directory-title'>" + @location.name)
end

Then /^Location name should be in the title$/ do
  page.html.should include("<title>" + @location.name)
end


