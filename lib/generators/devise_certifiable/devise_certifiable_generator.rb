module DeviseCertifiable
  module Generators
    class DeviseCertifiableGenerator < Rails::Generators::NamedBase
      namespace "devise_certifiable"
      
      desc "Add :certifiable directive in the given model and generate migration for ActiveRecord"

      def inject_devise_certifiable_content
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "certifiable, :", :after => "devise :") if File.exists?(path)
      end

      hook_for :orm
    end
  end
end
