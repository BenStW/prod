class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
   # You need to implement the method below in your model
#   session["facebook_token"] = request.env["omniauth.auth"].credentials.token
   logger.info("** begin find_for_facebook_oauth")
   @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
   logger.info("** end find_for_facebook_oauth")

   
   if @user.persisted?
     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"

     sign_in @user
     redirect_to welcome_url
     # sign_in_and_redirect @user, :event => :authentication
   else
     session["devise.facebook_data"] = request.env["omniauth.auth"]
     #redirect_to new_user_registration_url
   end
  end
end