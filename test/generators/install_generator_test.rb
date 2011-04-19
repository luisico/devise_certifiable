require "test_helper"
require 'rails/generators'
require "generators/devise_certifiable/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests DeviseCertifiable::Generators::InstallGenerator
  
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator
    assert_file "config/locales/devise_certifiable.en.yml"
  end
end
