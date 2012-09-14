class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
    @mode = params[:mode]
  end
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = 'Removed authentication provider.'
    redirect_to authentications_url
  end
  def create
    auth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(auth['provider'],auth['uid'])
    # render :text => auth['provider']
    if authentication
      flash[:notice] = 'Signed in successfully!'
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => auth['provider'], :uid => auth['uid'])
      flash[:notice] = 'Authentication successful!'
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth auth
      
      begin
        if user.save!
          flash[:notice] = 'Signed in successfully!'
          sign_in_and_redirect(:user, authentication.user)
        else
          session[:omniauth] = auth.except('extra')
          redirect_to new_user_registration_url
        end
      rescue ActiveRecord::RecordInvalid
        session[:omniauth] = auth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
end
