require 'test_helper'

class CertificationTest < ActionController::IntegrationTest
  def teardown
    Capybara.reset_sessions!
  end

  def visit_certify_with_token(token)
    visit edit_user_certification_path(:certification_token => token)
  end
  
  test 'new user need to be certified and confirmed before signing in' do
    admin = create_user
    user = sign_in_as_user
    assert page.has_selector? 'div#flash_alert', :text => 'Your account needs to be certified.'
    user.certify!(admin)
    sign_in_as_user(user)
    assert page.has_selector? 'div#flash_alert', :text => 'You have to confirm your account before continuing.'
    user.confirm!
    sign_in_as_user(user)
    assert page.has_selector? 'div#flash_notice', :text => 'Signed in successfully.'
    assert page.has_content? "Hello User #{user.email}!"
    assert page.has_content? 'Home!'
  end

  test 'certifier should login before certifying user' do
    user = create_user
    visit_certify_with_token user.certification_token
    assert page.has_selector? 'div#flash_alert', :text => 'You need to sign in or sign up before continuing.'

    admin = sign_in_as_admin
    visit_certify_with_token user.certification_token
    assert page.has_selector? 'h2', :text => 'User Certification'
    assert page.has_selector? 'label', :text => user.email
    assert page.has_button? 'Certify'
  end
  
  test 'complete certifications proces' do
    user = create_user
    admin = sign_in_as_admin
    visit_certify_with_token user.certification_token
    #click_button 'user_submit'
    flunk 'TODO'
  end
  

  test 'invalid certification token should produce an error' do
    admin = sign_in_as_admin
    visit_certify_with_token 'invalid_confirmation'
    assert page.has_selector? 'div#flash_alert', :text => 'The certification token provided is not valid!'
  end

  test 'new sign up should provide a message and redirect to root url' do
    visit new_user_registration_path
    fill_in 'user_email',    :with => 'test1@email.com'
    fill_in 'user_password', :with => '123456'
    fill_in 'user_password_confirmation', :with => '123456'
    click_button 'Sign up'
    # save_and_open_page

#    assert page.has_selector? 'div#flash_notice', :text => 'You have signed up successfully. However, we could not sign you in because your account is uncertified.'
#    assert_current_url "/"
#    assert_not warden.authenticated(:user)
#    assert page.has_button? 'Sign in'
    flunk 'TODO'
  end

  test 'already certified user should be presented with a message instead' do
    user = create_user
    user.certified_at = Time.now
    user.save
    
    admin = sign_in_as_admin
    visit_certify_with_token user.certification_token
    #save_and_open_page
    #assert page.has_selector? 'div#flash_notice', :text => 'Already certified'
    flunk 'TODO'
    
  end
end
