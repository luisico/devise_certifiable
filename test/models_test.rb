require 'test_helper'

class Certifiable < User
  devise :certifiable
end

class ModelsTest < ActiveSupport::TestCase
  def include_module?(klass, mod)
    klass.devise_modules.include?(mod) &&
    klass.included_modules.include?(Devise::Models::const_get(mod.to_s.classify))
  end

  def assert_include_modules(klass, *modules)
    modules.each do |mod|
      assert include_module?(klass, mod)
    end

    (Devise::ALL - modules).each do |mod|
      assert_not include_module?(klass, mod)
    end
  end

  test 'can cherry pick modules' do
    assert_include_modules User, :database_authenticatable, :recoverable, :confirmable, :registerable, :validatable, :certifiable
  end
end
