module DeviseCertifiable
  class Engine < ::Rails::Engine

    ActiveSupport.on_load(:action_controller) { include DeviseCertifiable::Controllers::UrlHelpers }
    ActiveSupport.on_load(:action_view)       { include DeviseCertifiable::Controllers::UrlHelpers }

    config.to_prepare do
      require 'devise/mailer'
      Devise::Mailer.send :include, DeviseCertifiable::Mailer
    end
  end
end
