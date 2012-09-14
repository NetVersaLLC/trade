class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :address, :skype, :company, :cell, :aim, :phone, :jabber, :yim, :facebook, :twitter, :latitude, :longitude, :name

  def apply_omniauth(auth)
    self.email = auth['user_info']['email'] if self.email.blank?
    authentications.build(:provider => auth['provider'], :uid => auth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
end
