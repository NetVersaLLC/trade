ActiveAdmin.register Authentication do
  controller do
    def permitted_params
      params.permit(:authentication => [:user_id, :provider, :uid])
    end
  end
end
