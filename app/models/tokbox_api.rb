require 'singleton'

class TokboxApi
  include Singleton
  
  def initialize
     @tokbox_api_obj = OpenTok::OpenTokSDK.new api_key, api_secret, :api_url => "https://api.opentok.com/hl"
  end

  def api_key
    13187652 
  end

  def api_secret
    '642b848da304d0d9cc8d547b7aee06ac50f8d3f9' 
  end
  
  # this method is called when creating a room
  def generate_session(remote_addr = "0.0.0.0")
   # logger.info "generates tokbox_session for IP #{remote_addr} " #" with P2P preference "
   # session_properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}
    @tokbox_api_obj.create_session remote_addr  #, session_properties
  end

  # the identification for each user within the chat
  def generate_token(tokbox_session_id, user, guest=false)
    if guest=="test"
        connection_data = { :user_id => user, :user_name => "User #{user}"} 
    else       
      connection_data = { :user_id => "#{user.id}", :user_name => "#{user.name}"} 
    end
    
    if(tokbox_session_id.nil? or user.nil?)
      raise "To generate a tokbox token the session and the user must exist"
    end
     @tokbox_api_obj.generate_token session_id: tokbox_session_id, connection_data: connection_data.to_json
  end
  
  def get_session_for_camera_test
    '1_MX4xMzE4NzY1Mn4wLjAuMC4wfjIwMTItMDMtMTggMTU6Mzk6MjQuODkxMTUzKzAwOjAwfjAuOTkzNTA0NjcwNzE5fg'
  end
  def generate_token_for_camera_test
    @tokbox_api_obj.generate_token session_id: get_session_for_camera_test
  end  

end