class Devise::CertificationsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  before_filter :authenticate_certifier!
  
  # GET /resource/certification/edit?certification_token=abcdef
  def edit
    self.resource = resource_class.find_resource_by_token(params[:certification_token])
    
    if resource.errors.empty?
      render_with_scope :edit
    else
      set_flash_message(:alert, :certification_token_invalid)
      redirect_to self.resource
    end
  end

  # PUT /resource/certification
  def update
    self.resource = resource_class.certify_by_token(params[resource_name][:certification_token], current_certifier)
    params[resource_name].delete(:certification_token)
    self.resource.update_attributes(params[resource_name])
    if resource.errors.empty?
      set_flash_message :notice, :certified
      redirect_to self.resource
    else
      render_with_scope :edit
    end
  end

  protected
  def current_certifier
    current_user
  end
end
