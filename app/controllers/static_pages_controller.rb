

class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!,  :except => [:welcome, :camera, :audio, :ben]
  
  def home
    if user_signed_in?
      if session[:appointment_token]
        redirect_to appointment_accept_url
      else
        home_logged_in
        render :action=>'home_logged_in'
      end
    else
       render 'home_not_logged_in'
    end    
  end
    
  def home_logged_in    
    #TODO this is hack
      @app = if Rails.env.production? then "330646523672055" else "232041530243765" end
      @friends = current_user.friends
      next_calendar_event = current_user.calendar_events.next
      if next_calendar_event
        @next_work_session = next_calendar_event.work_session
        users = @next_work_session.users - [current_user]
        @user_names = users.map(&:name).join(", ")
        if @user_names.blank?
          @user_names = t("static_pages.home_logged_in.nobody")
        else
          @user_names = t("static_pages.home_logged_in.with")+" "+@user_names
        end
        @room_host = @next_work_session.room.user.name
      end
  end
  
  def home_not_logged_in
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
  
  def info_for_work_session
    
  end
  
  
  def welcome
    if current_user.registered
      redirect_to root_url
    else
     current_user.registered=true
     current_user.save 
     @name = current_user.first_name
     @friends = current_user.friends
   end    
  end
  
  def welcome_session
    c = DateTime.current
    this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
    calendar_event = current_user.calendar_events.build(start_time: this_hour)
    calendar_event.find_or_build_work_session
    calendar_event.save
    work_session = calendar_event.work_session    
#    work_session = WorkSession.assign_for_guest(current_user)
 #   if work_session.nil?
#      redirect_to root_url, :alert=> "Aktuell ist keine WorkSession vorhanden, wo Du als Gast teilnehmen kannst."
#    else
    @work_buddies = work_session.users
#    end
  end
  
  def facebook

  end
  
# def send_facebook_message
#   @marked = params[:friends]
#   @message = params[:message]
#   redirect_to welcome_url    
# end
  
  def camera
    if params[:success]
      success = CameraAudio.find_or_create_by_user_id(current_user.id)
      success.video_success=params[:success]
      success.save
      redirect_to audio_url
    else
      @api_key = TokboxApi.instance.api_key
      @api_secret = TokboxApi.instance.api_secret
      @session_id = TokboxApi.instance.get_session_for_camera_test
      @tok_token = TokboxApi.instance.generate_token_for_camera_test
    end
  end  
  
  def audio
    if params[:success]
      success = CameraAudio.find_or_create_by_user_id(current_user.id)
      success.audio_success=params[:success]
      success.save
      if success.video_success==false or success.audio_success== false
        notice = t("static_pages.audio.no_success_msg")
      else
        notice = t("static_pages.audio.success_msg")
      end
      redirect_to root_url, :notice => notice
   end
 end

end
