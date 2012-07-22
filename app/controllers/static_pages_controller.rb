class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!,  :except => [:welcome, :camera, :ben,:info_for_group_hour]
  
  def home
    session[:appointment_token] = nil
    if user_signed_in?
      if token = session[:appointment_token]
        session[:appointment_token] = nil
        redirect_to accept_url(:token=>token)
      else
        home_logged_in
        render :action=>'home_logged_in'
      end
    else
       render 'home_not_logged_in'
    end    
  end
    
  def home_logged_in    
      @my_appointments = current_user.appointments.this_week
      @my_received_appointments = current_user.received_appointments.this_week.without_accepted(current_user)
      @friends_appointments = Appointment.this_week.friends_of(current_user)

      @active_users = User.current_users

      @friends = current_user.friends
      next_user_hour = current_user.user_hours.next
      if next_user_hour
        @next_group_hour = next_user_hour.group_hour
        users = @next_group_hour.users - [current_user]
        @user_names = users.map(&:name).join(", ")
        if @user_names.blank?
          @user_names = t("static_pages.home_logged_in.nobody")
        else
          @user_names = t("static_pages.home_logged_in.with")+" "+@user_names
        end
      end
      if !current_user.camera
        current_user.create_camera
      end
      @camera = current_user.camera
  end
  
  def home_not_logged_in
  end
  


  def login_to_accept_appointment  
     token = params["token"]
     session[:appointment_token] = token
     @appointment = Appointment.find_by_token!(token)
  end



  # called by *omniauth_callbacks_controller.rb*
  def welcome
    if current_user.registered
      redirect_to root_url
    else
      current_user.registered=true
      current_user.save    
      if token = session[:appointment_token]
        session[:appointment_token] = nil
        redirect_to accept_and_redirect_to_appointment_with_welcome_url(:token=>token)
      else
         @name = current_user.first_name
        @friends = current_user.friends
     end
  end    
  end
  
 
 def how_it_works
 end
 def effect
 end  
 def pilot_study
 end
 def scientific_principles
 end
 
 def impressum
 end
 def about_us
 end
 
 def ben
   
 end
 
 def blog
 end
 
 def info_for_group_hour
   
 end
 
 def users_tomorrow
   a = Array.new
   10.times do
     a << current_user
   end
   @users =  User.users_tomorrow
 end
 
 def send_exception
   message = params["message"]
   ErrorMailer.deliver_frontend_exception(message,current_user).deliver
   render :text => "ok"  
 end
 
 def test_mail_layout
   @user=User.first
   @appointment = Appointment.first
   @users = Array.new
   10.times.each do |u|
     @users << @user
   end
 # render "start_work_mailer/after_registration", :layout =>'mail_layout'
  render "start_work_mailer/after_creation_of_appointment", :layout =>'mail_layout'
 end
end
