require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @problem = problems(:one)
  end

  test "should get index" do
    get problems_url
    assert_response :success
  end

  test "should get new" do
    get new_problem_url
    assert_response :success
  end

  test "should create problem" do
    assert_difference('Problem.count') do
      post problems_url, params: { problem: { description: @problem.description, title: @problem.title } }
    end

    assert_redirected_to problem_url(Problem.last)
  end

  test "should show problem" do
    get problem_url(@problem)
    assert_response :success
  end

  test "should get edit" do
    get edit_problem_url(@problem)
    assert_response :success
  end

  test "should update problem" do
    patch problem_url(@problem), params: { problem: { description: @problem.description, title: @problem.title } }
    assert_redirected_to problem_url(@problem)
  end

  test "should destroy problem" do
    assert_difference('Problem.count', -1) do
      delete problem_url(@problem)
    end

    assert_redirected_to problems_url
  end
end
