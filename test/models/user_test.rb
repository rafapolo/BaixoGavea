require "test_helper"

class UserTest < ActiveSupport::TestCase
  def build_user(attrs = {})
    User.new({
      username: "polo",
      email: "polo@example.com",
      info: "aways over here",
      password: "polopolo",
      password_confirmation: "polopolo"
    }.merge(attrs))
  end

  test "valid user saves and normalizes the username" do
    user = build_user(username: "Polo Silva")
    assert user.save
    assert_equal "PoloSilva", user.username
    assert_equal "polosilva", user.normalizado
  end

  test "requires a username" do
    user = build_user(username: "")
    assert_not user.save
    assert_includes user.errors[:username], "can't be blank"
  end

  test "requires a unique username" do
    build_user.save!
    duplicate = build_user(email: "outro@example.com")
    assert_not duplicate.save
    assert_includes duplicate.errors[:username], "has already been taken"
  end

  test "requires a well formed email" do
    user = build_user(email: "not-an-email")
    assert_not user.save
  end

  test "authenticates with the correct password" do
    user = build_user.tap(&:save!)
    assert user.authenticate("polopolo")
    assert_not user.authenticate("wrong")
  end

  test "confirmado scope only returns confirmed users" do
    confirmed = build_user(confirmado: true).tap(&:save!)
    build_user(username: "outro", email: "outro@example.com", confirmado: false).save!

    assert_equal [confirmed], User.confirmado.to_a
  end
end
