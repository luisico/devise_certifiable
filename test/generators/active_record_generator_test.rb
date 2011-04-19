require "test_helper"
require "rails/generators/test_case"

if DEVISE_ORM == :active_record
  require "generators/active_record/devise_certifiable_generator"

  class ActiveRecordGeneratorTest < Rails::Generators::TestCase
    tests ActiveRecord::Generators::DeviseCertifiableGenerator
    
    destination File.expand_path("../../tmp", __FILE__)
    setup :prepare_destination
  
    test "migration is properly created" do
      run_generator %w(monster)
      assert_migration "db/migrate/devise_certifiable_add_to_monsters.rb"
    end
  
    test "all files are properly deleted" do
      run_generator %w(monster)
      run_generator %w(monster), :behavior => :revoke
      assert_no_migration "db/migrate/devise_create_monsters.rb"
    end
  end
end
