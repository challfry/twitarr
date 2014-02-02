require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase
  subject { User }
  let(:attributes) { %w(username password is_admin status email last_login last_checked_posts security_question security_answer) }

  include AttributesTest
  include UpdateTest

  it 'is not valid without username' do
    user = User.new(email: 'foo@bar.com', security_question: 'd', security_answer: 'b')
    user.valid?.must_equal false
  end

  it 'is not valid when username is not valid' do
    user = User.new(username: 'a', email: 'foo@bar.com', security_question: 'd', security_answer: 'b')
    user.valid?.must_equal false
  end

  it 'is not valid when email is not valid' do
    user = User.new(username: 'foobar', email: 'foobar', security_question: 'd', security_answer: 'b')
    user.valid?.must_equal false
  end

  it 'is not valid when display name not valid' do
    user = User.new(username: 'foobar', email: 'foo@bar.com', display_name: 'a', security_question: 'd', security_answer: 'b')
    user.valid?.must_equal false
  end

  it 'has to have a security question' do
    user = User.new(username: 'foobar', email: 'foo@bar.com', security_answer: 'b')
    user.valid?.must_equal false
  end

  it 'has to have a security answer' do
    user = User.new(username: 'foobar', email: 'foo@bar.com', security_question: 'b')
    user.valid?.must_equal false
  end

  it 'allows characters in usernames' do
    User.valid_username?('steve').must_equal true
  end

  it 'allows numbers in usernames' do
    User.valid_username?('steven12').must_equal true
  end

  it 'allows underscores in usernames' do
    User.valid_username?('steven_12').must_equal true
  end

  it 'allows dashes in usernames' do
    User.valid_username?('steven-12').must_equal true
  end

  it 'allows ampersands in usernames' do
    User.valid_username?('steven&mary').must_equal true
  end

  it 'disallows short usernames' do
    User.valid_username?('st').must_equal false
  end

  it 'disallows spaces in usernames' do
    User.valid_username?('stan evanston').must_equal false
  end

  it 'disallows periods in usernames' do
    User.valid_username?('stan.evanston').must_equal false
  end

  it 'allows characters in display name' do
    User.valid_display_name?('steve').must_equal true
  end

  it 'allows numbers in display name' do
    User.valid_display_name?('steven12').must_equal true
  end

  it 'allows underscores in display_names' do
    User.valid_display_name?('steven_12').must_equal true
  end

  it 'allows dashes in display_names' do
    User.valid_display_name?('steven-12').must_equal true
  end

  it 'allows ampersands in display_names' do
    User.valid_display_name?('steven&mary').must_equal true
  end

  it 'disallows short display_names' do
    User.valid_display_name?('st').must_equal false
  end

  it 'allows spaces in display names' do
    User.valid_display_name?('stan evanston').must_equal true
  end

  it 'allows periods in display names' do
    User.valid_display_name?('mr. evanston').must_equal true
  end

  it 'disallows % characters in display names' do
    User.valid_display_name?('mr% evanston').must_equal false
  end

  it 'only allows 40 characters for display_name' do
    User.valid_display_name?('01234567890123456789012345678901234567890').must_equal false
  end

  it 'updates the last_login timestamp' do
    user = User.new
    user.last_login.must_equal nil
    user.update_last_login
    user.last_login.must_be_close_to Time.now.to_f
  end

  it 'returns user from update_last_login' do
    user = User.new
    test = user.update_last_login
    test.must_equal user
  end

  it 'downcases the security answer' do
    user = User.new security_answer: 'FOO'
    user.security_answer.must_equal 'foo'
    user.security_answer = 'BAR'
    user.security_answer.must_equal 'bar'
  end

  it 'trims the display name' do
    user = User.new display_name: ' foo '
    user.display_name.must_equal 'foo'
    user.display_name = ' bar '
    user.display_name.must_equal 'bar'
  end

end
