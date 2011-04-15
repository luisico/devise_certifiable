module DeviseCertifiable::Controllers::Helpers
  protected
  def authenticate_certifier!
    send(:"authenticate_#{resource_name}!", true)
  end
end
ActionController::Base.send :include, DeviseCertifiable::Controllers::Helpers
