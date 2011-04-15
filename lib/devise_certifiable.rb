require 'devise'

require 'devise_certifiable/mailer'
require 'devise_certifiable/routes'
require 'devise_certifiable/schema'
require 'devise_certifiable/controllers/url_helpers'
require 'devise_certifiable/controllers/helpers'
require 'devise_certifiable/rails'

module Devise
end

Devise.add_module :certifiable, :model => 'devise_certifiable/model', :route => :certification, :controller => :certifications
