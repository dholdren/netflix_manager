require 'test_helper'

class MovieQueueTest < ActiveSupport::TestCase


  setup do
    stub_netflix_for_user('nuid_one')
    stub_netflix_for_user('nuid_sub1')
    stub_netflix_for_user('nuid_sub2')
  end
  
  test "test user get all queues" do
    user = users('one')

    all_queues = user.disc_queues
    assert_equal 3, all_queues.size
    assert_equal 3, all_queues[0].discs.size
  end

  test "test add to queue" do
    user = users('one')
    nuid_one_queue = user.profiles.where("netflix_user_id = ?", 'nuid_one')[0].disc_queue
    #title_id, position, etag
    result = nuid_one_queue.add("70075479", "2")
    
    #assert_nothing_raised("result should be a queue that we can call discs on") { 
    #  result.discs
    #}
  end
  
  test "test remove from queue" do
    user = users('one')
    nuid_sub1_queue = user.profiles.where("netflix_user_id = ?", 'nuid_sub1')[0].disc_queue
    #position/title_id
    result = nuid_sub1_queue.remove(1)
    
    #assert_nothing_raised("result should be a queue that we can call discs on") { 
    #  result.discs
    #}
  end
  
end
