module DeviseCertifiable
  module Schema
    def certifiable
      apply_devise_schema :certification_token, String, :limit => 60
      apply_devise_schema :certified_at, DateTime
      apply_devise_schema :certified_by_id, Integer 
      apply_devise_schema :certified_by_type, String 
    end
  end
end

Devise::Schema.send :include, DeviseCertifiable::Schema
