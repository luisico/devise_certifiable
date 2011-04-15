module ActionDispatch::Routing
  class Mapper
    
    protected
    def devise_certification(mapping, controllers)
      resource :certification, :only => [:edit, :update],
      :path => mapping.path_names[:certification], :controller => controllers[:certifications]
    end
  end
end
