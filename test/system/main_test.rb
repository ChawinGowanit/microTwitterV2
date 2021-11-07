require "application_system_test_case"

class MainTest < ApplicationSystemTestCase
  test "login success" do
    visit "/main"
    fill_in "Email", with: "u1"
    fill_in "Password", with: "1234"
    click_on "Login"
    assert_selector "p", text: "Login successfully."
  end
  test "login wrong email" do
    visit "/main"
    fill_in "Email", with: "XXXX"
    fill_in "Password", with: "1234"
    click_on "Login"
    assert_selector "p", text: "Incorrect Email or Password."
  end
  test "login wrong password" do
    visit "/main"
    fill_in "Email", with: "u1"
    fill_in "Password", with: "XXXX"
    click_on "Login"
    assert_selector "p", text: "Incorrect Email or Password."
  end
  test "likefeed" do
    visit "/main"
    fill_in "Email", with: "u1"
    fill_in "Password", with: "1234"
    click_on "Login"
    click_on "Like"
    assert_selector "p", text: "liked"
  end
end