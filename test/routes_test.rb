require 'test_helper'

class CertifiableRoutesTest < ActionController::TestCase
  test 'map edit user certification' do
    assert_recognizes({:controller => 'devise/certifications', :action => 'edit'}, {:path => 'users/certification/edit', :method => :get})
  end

  test 'map update user certification' do
    assert_recognizes({:controller => 'devise/certifications', :action => 'update'}, {:path => 'users/certification', :method => :put})
  end
end
