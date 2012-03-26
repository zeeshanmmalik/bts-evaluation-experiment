require 'test_helper'

class SurveyControllerTest < ActionController::TestCase
  test "should get access" do
    get :access
    assert_response :success
  end

  test "should get submit" do
    get :submit
    assert_response :success
  end

end
