# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/




# document needs to be loaded, as parameters are passed from DOM to JS
$(document).ready ->
	
  
  # only run code when videobox is present
  if $('#camera_settings').length > 0 
    
    $("#session_start_success").click ->
       $.ajax
          url: $("#urls").data("camera_url")+"?success=true"
          type: "GET"
    
    if $("#flash_version").length>0
       playerVersion= swfobject.getFlashPlayerVersion()
       flash_version =  playerVersion.major + "." + playerVersion.minor + "." + playerVersion.release
       if playerVersion.major < 11
          $("#flash_version").html(flash_version)
       else
          $("#flash_version_alert").css("display","none")	
	
    publisher = null
    TB.setLogLevel(TB.DEBUG) 
    session_id  = $("#camera_settings").data("session_id")
    tok_token = $("#camera_settings").data("tok_token")
    api_key = $("#camera_settings").data("api_key")
    session = TB.initSession session_id

    windowProps = 
      width: 220
      height: 220
    
    # The Session object dispatches SessionConnectEvent object when a session has successfully connected
    # in response to a call to the connect() method of the Session object.
    sessionConnectedHandler = (event) ->
       replaceElementId = 'publisher_box_tmp'
       publisher = session.publish replaceElementId, windowProps       
    
    session.addEventListener 'sessionConnected', sessionConnectedHandler
    session.connect api_key, tok_token

