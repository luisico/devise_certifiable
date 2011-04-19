require 'test_helper'
require 'rails/generators'
require "generators/devise_certifiable/devise_certifiable_generator"

class DeviseCertifiableGeneratorTest < Rails::Generators::TestCase
  tests DeviseCertifiable::Generators::DeviseCertifiableGenerator
  
  destination File.expand_path("../../tmp", __FILE__)

  setup do
    prepare_destination
    copy_model
  end

  test "add :certifiable to model" do
#    run_generator %w(monster)
#    assert_file "app/models/monster.rb", /devise :certifiable/
    flunk 'TODO'
  end

  def copy_model
    model = File.expand_path("../../rails_app/app/models/monster.rb", __FILE__)
    destination = File.join(destination_root, 'app/models')
    FileUtils.mkdir_p(destination)
    FileUtils.cp model, destination
  end
end
