require 'shared_user'

class User < ActiveRecord::Base
  include SharedUser

  attr_accessible :username, :email, :password, :password_confirmation
end
