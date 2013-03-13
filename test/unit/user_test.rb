require 'test_helper'

class UserTest < ActiveSupport::TestCase

should have_many(:user_friendships)
should have_many(:friends)

test "a user should enter a first name" do
 	user = User.new
 	assert !user.save
 	assert !user.errors[:first_name].empty?
 end

 test "a user should enter a last name" do
 	user = User.new
 	assert !user.save
 	assert !user.errors[:last_name].empty?
 end

test "a user should enter a profile name" do
 	user = User.new
 	assert !user.save
 	assert !user.errors[:profile_name].empty?
 end

 test "a user should enter a unique profile name" do
 	user = User.new
 	user.profile_name = users(:jason).profile_name
 	assert !user.save
 	assert !user.errors[:profile_name].empty?
 end

 test "a user should have a profile name without spaces" do
 	user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
 	user.password = user.password_confirmation = "asdffdsa"
 	user.profile_name = "profile with space"

 	assert !user.save
 	assert !user.errors[:profile_name].empty?
 	assert user.errors[:profile_name].include?("Profile name formatted incorrectly. Letters and numbers only.  No spaces.")
 end

 test "a user should have a correctly formatted profile name" do
 	user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
 	user.password = user.password_confirmation = "asdffdsa"
 	user.profile_name = "jasonSeifer_1"
 	assert user.valid?
 end
 
 test "that no error is raised when trting to access a friend list" do

 	assert_nothing_raised do
 		users(:jason).friends
 	end
 end

 test "that creating friendships on a user works" do

 	users(:jason).pending_friends  << users(:mike)
 	users(:jason).pending_friends.reload
 	assert users(:jason).pending_friends.include?(users(:mike))

 end

 test "that calling to_param on a user returns the profile_name" do

 assert_equal "jasonseifer", users(:jason).to_param

 end


end
