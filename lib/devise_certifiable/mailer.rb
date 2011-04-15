module DeviseCertifiable
  module Mailer
    # Request certification from  certification authority
    def certification_request(record)
      mail = setup_mail(record, :certification_request)
      mail.to = mailer_sender(@devise_mapping)
      return mail
    end
  end
end
