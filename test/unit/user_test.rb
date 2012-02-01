require 'test_helper'
#require 'mocha'
require 'fakeweb'


class UserTest < ActiveSupport::TestCase
  setup do
  end
  
  test "test user get profiles" do
    user = User.find_by_name("Jane Smith")
    assert_equal 3, user.profiles.count
  end
  
  test "test user profiles order" do
    user = User.find_by_name("Jane Smith")
    assert_equal 1, user.profiles[0].position
    assert_equal 2, user.profiles[1].position
    assert_equal 3, user.profiles[2].position
  end
  
  test "user profile has a name" do
    user = User.find_by_name("Jane Smith")
    assert_equal "Jane Smith", user.profiles[0].name
  end
  
  test "test user get queues" do
    user = User.find_by_name("Jane Smith")
    user.profiles.each {|profile| stub_netflix_for_user(profile.netflix_user_id)}
    assert user.disc_queues
    assert_equal 3, user.disc_queues.count
  end
  
end
