module SharedUser
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :confirmable, :recoverable, :registerable, :validatable, :certifiable
  end
end
