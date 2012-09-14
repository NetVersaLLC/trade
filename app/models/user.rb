class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable
  validates :email, :uniqueness => true,  :presence => true, :if => :email_required?  
  validates :password, :presence => true, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :address, :skype, :company, :cell, :aim, :phone, :jabber, :yim, :facebook, :twitter, :latitude, :longitude, :name

  def apply_omniauth(auth)
    
    self.email = auth['user_info']['email'] if self.email.blank?
    self.name = auth['user_info']['name'] if self.name.blank?
    authentications.build(:provider => auth['provider'], :uid => auth['uid'])
  end

  def email_required?
     (authentications.empty? || !password.blank?)
  end

  def password_required?
    (authentications.empty? || !password.blank?) && (!persisted? || !password.nil? || !password_confirmation.nil?)
  end
end
