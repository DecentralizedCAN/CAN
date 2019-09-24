require 'test_helper'

class CriteriaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @criterium = criteria(:one)
  end

  test "should get index" do
    get criteria_url
    assert_response :success
  end

  test "should get new" do
    get new_criterium_url
    assert_response :success
  end

  test "should create criterium" do
    assert_difference('Criterium.count') do
      post criteria_url, params: { criterium: { alternatives: @criterium.alternatives, problem_id: @criterium.problem_id, title: @criterium.title } }
    end

    assert_redirected_to criterium_url(Criterium.last)
  end

  test "should show criterium" do
    get criterium_url(@criterium)
    assert_response :success
  end

  test "should get edit" do
    get edit_criterium_url(@criterium)
    assert_response :success
  end

  test "should update criterium" do
    patch criterium_url(@criterium), params: { criterium: { alternatives: @criterium.alternatives, problem_id: @criterium.problem_id, title: @criterium.title } }
    assert_redirected_to criterium_url(@criterium)
  end

  test "should destroy criterium" do
    assert_difference('Criterium.count', -1) do
      delete criterium_url(@criterium)
    end

    assert_redirected_to criteria_url
  end
end
