require 'test_helper'

class RoutesTest < ActionController::TestCase
  tests ApplicationController

  def assert_path_and_url(name, prepend_path=nil)
    @request.path = '/users/session'
    prepend_path = "#{prepend_path}_" if prepend_path

    # Resource param
    assert_equal @controller.send(:"#{prepend_path}#{name}_path", :user),
                 send(:"#{prepend_path}user_#{name}_path")
    assert_equal @controller.send(:"#{prepend_path}#{name}_url", :user),
                 send(:"#{prepend_path}user_#{name}_url")

    # Default url params
    assert_equal @controller.send(:"#{prepend_path}#{name}_path", :user, :param => 123),
                 send(:"#{prepend_path}user_#{name}_path", :param => 123)
    assert_equal @controller.send(:"#{prepend_path}#{name}_url", :user, :param => 123),
                 send(:"#{prepend_path}user_#{name}_url", :param => 123)

    @request.path = nil
    # With an object
    assert_equal @controller.send(:"#{prepend_path}#{name}_path", User.new),
                 send(:"#{prepend_path}user_#{name}_path")
    assert_equal @controller.send(:"#{prepend_path}#{name}_url", User.new),
                 send(:"#{prepend_path}user_#{name}_url")
  end

  test 'should alias certification to mapped user certification' do
    assert_path_and_url :certification
    assert_path_and_url :certification, :edit
  end
end
