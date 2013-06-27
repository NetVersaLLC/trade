ActiveAdmin.register User do
  controller do
    def permitted_params
      params.permit(:user => [:email, :name, :address, :phone, :aim, :jabber, :skype, :latitude, :longitude, :updated_at, :yim, :show_email])
    end
  end
end
