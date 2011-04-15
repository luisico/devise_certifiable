module DeviseCertifiable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      
      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise_certifiable.en.yml"
      end
    end
  end
end
