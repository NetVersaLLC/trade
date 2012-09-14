class Authentication < ActiveRecord::Base
  belongs_to :user
  def provider_name
    if provider == 'open_id'
      'OpenID'
    else
      provider.titleize
    end
  end
  def provider_uid
    if provider == 'open_id' or provider == 'google_apps'
      ''
    else
      uid
    end
  end
end
