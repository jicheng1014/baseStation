require 'test_helper'

class PlacemarkControllerTest < ActionController::TestCase
  test "should get import" do
    get :import
    assert_response :success
  end

end
