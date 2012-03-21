require 'test_helper'

class BugReportsControllerTest < ActionController::TestCase
  setup do
    @bug_report = bug_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bug_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bug_report" do
    assert_difference('BugReport.count') do
      post :create, bug_report: @bug_report.attributes
    end

    assert_redirected_to bug_report_path(assigns(:bug_report))
  end

  test "should show bug_report" do
    get :show, id: @bug_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bug_report
    assert_response :success
  end

  test "should update bug_report" do
    put :update, id: @bug_report, bug_report: @bug_report.attributes
    assert_redirected_to bug_report_path(assigns(:bug_report))
  end

  test "should destroy bug_report" do
    assert_difference('BugReport.count', -1) do
      delete :destroy, id: @bug_report
    end

    assert_redirected_to bug_reports_path
  end
end
