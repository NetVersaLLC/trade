class User < ActiveRecord::Base
  blogs
  
  attr_accessor :current_password

  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable #, :validatable
  validates :email, uniqueness: true, presence: true, 
                    format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }, if: :email_required?

  validates :password, :presence => true, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?

  #validate :current_password_should_match, if: :need_password_confirmation?

  def self.from_omniauth(auth_data)
    auth = Authentication.where(auth_data.slice(:provider, :uid)).first_or_create! do |authentication|
      authentication.provider = auth_data.provider
      authentication.uid = auth_data.uid
      user = User.new(name: auth_data.info.name)
      user.save(validate: false)
      authentication.user = user
    end
    auth.user
  end

  def email_required?
     (authentications.empty? || !password.blank?)
  end

  def password_required?
    (authentications.empty? || !password.blank?) && (!persisted? || !self.password.nil? || !password_confirmation.nil?)
  end

  private
  
  def need_password_confirmation?
    password_required? && !new_record?  
  end

  def current_password_should_match
     errors.add(:current_password, "doesn't match") if !valid_password?(self.current_password)
  end
end
