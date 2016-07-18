require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:clark)
  end

  test "unsuccessfull edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "qwe@net", password: "123", password_confirmation: "213" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end

  test "successfull edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Barry Allen"
    email = "fast@jl.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    #follow_redirect!
    #assert_template 'users/show'
    #assert_not flash.empty?
  end

  test "successfull edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Qwe Rty"
    email = "qwerty@gmail.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end
