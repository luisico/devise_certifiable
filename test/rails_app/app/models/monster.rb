if DEVISE_ORM == :active_record
  class Monster < ActiveRecord::Base
    devise :database_authenticatable, :validatable, :confirmable, :encryptable
  end
end
