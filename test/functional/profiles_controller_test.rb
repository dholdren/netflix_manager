require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  # test "the truth" do
  #   assert true
  # end
  setup do
    stub_netflix_for_user('nuid_one')
    stub_netflix_for_user('nuid_sub1')
    stub_netflix_for_user('nuid_sub2')
  end
  
  test "logged in redirected to profiles page" do
    sign_in User.first
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end
  
  test "json retrieval works" do
    sign_in User.first
    @request.accept = "application/json"
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
    assert_equal 'application/json', @response.content_type
    response_obj = JSON.parse(@response.body)
    assert response_obj
    assert_equal 3, response_obj.size
    assert response_obj[0], "expecting a first element (profile)"
    assert response_obj[0]["id"], "expecting an id for first element (profile)"
    assert_equal "Jane Smith", response_obj[0]["name"]
    assert response_obj[0]["disc_queue"], "expecting a queue"
    assert response_obj[0]["disc_queue"]["id"], "expecting a queue id"
    assert response_obj[0]["disc_queue"]["etag"], "expecting a queue etag"
    assert response_obj[0]["disc_queue"]["discs"], "expecting discs"
    assert response_obj[0]["disc_queue"]["discs"][0], "expecting a disc"
    assert response_obj[0]["disc_queue"]["discs"][0]["id"], "expecting a disc id"
    assert response_obj[0]["disc_queue"]["discs"][0]["title"], "expecting a disc title"
  end
end
