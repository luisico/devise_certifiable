class ActionController::IntegrationTest
  def warden
    request.env['warden']
  end

  def create_user(options={})
    user ||= begin
      user = User.create!(
        :username => 'usertest',
        :email => generate_unique_email,
        :password => options[:password] || '123456',
        :password_confirmation => options[:password] || '123456',
        :created_at => Time.now.utc
      )
      user.certify!(user) if options[:certify] == true
      user.confirm! if options[:confirm] == true
      user
    end
  end

  def sign_in_as_user(user = nil)
    user ||= create_user
    visit new_user_session_path
    fill_in 'user_email',    :with => user.email
    fill_in 'user_password', :with => '123456'
    click_button 'user_submit'
    user
  end

  def sign_in_as_admin
    admin = create_user(:certify => true, :confirm => true)
    sign_in_as_user(admin)
  end
  
  # Fix assert_redirect_to in integration sessions because they don't take into
  # account Middleware redirects.
  
  def assert_redirected_to(url)
    assert [301, 302].include?(@integration_session.status),
           "Expected status to be 301 or 302, got #{@integration_session.status}"

    assert_url url, @integration_session.headers["Location"]
  end

  def assert_current_url(expected)
    assert_url expected, current_url
  end

  def assert_url(expected, actual)
    assert_equal prepend_host(expected), prepend_host(actual)
  end

  protected

  def prepend_host(url)
    url = "http://#{request.host}#{url}" if url[0] == ?/
    url
  end
end
