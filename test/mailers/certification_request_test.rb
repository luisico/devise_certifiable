require 'test_helper'

class CertificationRequestTest < ActionMailer::TestCase

  def setup
    setup_mailer
    Devise.mailer_sender = 'test@example.com'
  end

  def user
    @user ||= create_user
  end

  def mail
    @mail ||= begin
      user
      ActionMailer::Base.deliveries.first
    end
  end

  test 'email sent after creating the user' do
    assert_not_nil mail
  end

  test 'content type should be set to html' do
    assert mail.content_type.include?('text/html')
  end

  test 'send confirmation instructions to the user email' do
    mail
    assert_equal ['test@example.com'], mail.to
  end

  test 'setup sender from configuration' do
    assert_equal ['test@example.com'], mail.from
  end

  test 'setup reply to as copy from sender' do
    assert_equal ['test@example.com'], mail.reply_to
  end

  test 'setup subject from I18n' do
    store_translations :en, :devise => { :mailer => { :certification_request => { :subject => 'New Certification Request' } } } do
      assert_equal 'New Certification Request', mail.subject
    end
  end

  test 'subject namespaced by model' do
    store_translations :en, :devise => { :mailer => { :certification_request => { :user_subject => 'User Certification Request' } } } do
      assert_equal 'User Certification Request', mail.subject
    end
  end

  test 'body should have user info' do
    assert_match /#{user.email}/, mail.body.encoded
  end

  test 'body should have link to certify the account' do
    host = ActionMailer::Base.default_url_options[:host]
    edit_certification_url_regexp = %r{<a href=\"http://#{host}/users/certification/edit\?certification_token=#{user.certification_token}">}
    assert_match edit_certification_url_regexp, mail.body.encoded
  end
end
