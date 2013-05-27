class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, resource_params)
                             @user.update_with_password(resource_params)
                           else
                             resource_params.delete(:current_password)
                             @user.update_without_password(resource_params)
                           end

    if successfully_updated
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path
    else
      render 'edit'
    end
  end

  private

  def needs_password?(user, params)
    (user.email != params[:email] && !params[:email].blank?) ||
        !params[:password].blank?
  end

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :address, :phone, :skype, :aim, :yim, :jabber, :latitude, :longitudea)
  end
end
