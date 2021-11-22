class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2, :facebook]
  include DeviseTokenAuth::Concerns::User
  validates_uniqueness_of :email

  has_many :scopes
  has_many :scope_users, dependent: :destroy

  def has_role?(role)
     !self.roles.nil? && self.roles.split(",").include?(role)
   end
 
   def is_admin?
     has_role?("admin")
   end

end