require 'test_helper'

class CertifiableTest < ActiveSupport::TestCase

  def setup
    setup_mailer
  end

  test 'should generate certification token after creating a record' do
    assert_nil new_user.certification_token
    assert_not_nil create_user.certification_token
  end

  test 'should not generate certification token if already certified' do
    flunk 'TODO'
  end

  test 'should never generate the same certification token for different users' do
    certification_tokens = []
    3.times do
      token = create_user.certification_token
      assert !certification_tokens.include?(token)
      certification_tokens << token
    end
  end

  test 'should certify a user by updating certfied at and certified by' do
    admin = create_user
    user = create_user
    assert_nil user.certified_at
    assert_nil user.certified_by
    assert user.certify!(admin)
    assert_not_nil user.certified_at
    assert_not_nil user.certified_by
    assert_equal user.certified_by, admin
  end

  test 'should clear certification token while certifiying a user' do
    admin = create_user
    user = create_user
    assert_present user.certification_token
    user.certify!(admin)
    assert_nil user.certification_token
  end

  test 'should not certify without a certification_authority' do
    user = create_user
    assert_not user.certify!(nil)
    assert_equal "(certification authority) not specified", user.errors[:certified_by].join

    user2 = create_user
    assert_not user2.certify!('')
    assert_equal "(certification authority) not specified", user2.errors[:certified_by].join
  end
  
  test 'should verify whether a user is certified' do
    admin = create_user
    assert_not new_user.certified?
    user = create_user
    assert_not user.certified?
    user.certify!(admin)
    assert user.certified?
  end

  test 'should not certify a user already certified' do
    admin = create_user
    user = create_user
    assert user.certify!(admin)
    assert_blank user.errors[:email]
    assert_not user.certify!(admin)
    assert_equal "was already certified!", user.errors[:email].join
  end

  test 'should find a user by token, but not certify it' do
    user = create_user
    certifiable_user = User.find_resource_by_token(user.certification_token)
    assert_equal certifiable_user, user
    assert_not user.reload.certified?
  end
  
  test 'should find a user by token and certify it' do
    admin = create_user
    user = create_user
    certifiable_user = User.certify_by_token(user.certification_token, admin)
    assert_equal certifiable_user, user
    assert user.reload.certified?
  end

  test 'should return a new record with errors when a invalid token is given' do
    certifiable_user = User.find_resource_by_token('invalid_certification_token')
    assert_not certifiable_user.persisted?
    assert_equal "is invalid", certifiable_user.errors[:certification_token].join
  end

  test 'should return a new record with errors when a blank or nil token is given' do
    certifiable_user = User.find_resource_by_token('')
    assert_not certifiable_user.persisted?
    assert_equal "can't be blank", certifiable_user.errors[:certification_token].join
    certifiable_user = User.find_resource_by_token(nil)
    assert_not certifiable_user.persisted?
    assert_equal "can't be blank", certifiable_user.errors[:certification_token].join
  end

  test 'should send certification instructions by email only after creating user' do
    assert_email_sent do
      create_user
    end
  end

  test 'should not send certification instructions by email before creating user' do
    assert_email_not_sent do
      new_user
    end
  end

  test 'should not send certification when trying to save an invalid user' do
 #   assert_email_not_sent do
 #     user = new_user
 #     user.stubs(:valid?).returns(false)
 #     user.save
 #   end
    flunk 'TODO'
  end

  test 'should always have certification token when email is sent' do
    user = new_user
    user.save
    user.request_certification
    assert_not_nil user.reload.certification_token
  end

  test 'should automatically certify new invited user with inviter' do
    admin = create_user
    user = User.invite!(
      { :username => "usertest", :email => generate_unique_email }, admin)
    assert_nil user.reload.certification_token
    assert_not_nil user.certified_at
    assert_equal user.certified_by, admin
  end

  test 'should not send instructions if the user is already certified' do
    admin = create_user
    user = create_user
    user.certify!(admin)
    assert_email_not_sent do
      user.certify!(admin)
    end
  end

  test 'should not send confirmation instructions before being certified' do
    admin = create_user
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = create_user
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert_equal 'Certification request', ActionMailer::Base.deliveries.last.subject
    user.certify!(admin)
    assert_equal 3, ActionMailer::Base.deliveries.size
    assert_equal 'Confirmation instructions', ActionMailer::Base.deliveries.last.subject
  end

  test 'should be active after being certified and confirmed' do
    admin = create_user
    user = create_user
    assert_not user.active_for_authentication?
    assert_equal :uncertified, user.inactive_message
    user.certify!(admin)
    assert_not user.active_for_authentication?
    assert_equal :unconfirmed, user.inactive_message
    user.confirm!
    assert user.reload.active_for_authentication?
  end
end
