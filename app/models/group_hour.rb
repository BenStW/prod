# == Schema Information
#
# Table name: group_hours
#
#  id                :integer         not null, primary key
#  start_time        :datetime
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class GroupHour < ActiveRecord::Base
   validates :start_time, :tokbox_session_id, :presence => true
   validate :users_cant_be_more_then_five
   has_many :user_hours
   has_many :users, :through=> :user_hours
   
   before_destroy :has_no_user_hours?
   before_create :generate_tokbox_session_id
   # don't fill tokbox_session_id with before_create because the IP of current_user needs to be overgiven
   
   def self.this_week
     where("start_time>?",DateTime.current-1.hour) 
   end   
   
   def users_cant_be_more_then_five
     if users.count>5
       errors.add(:users, "Users can't be more then 5 for GroupHour (#{id})")
     end
   end   
   
    
   def has_no_user_hours?
      self.user_hours.count == 0
   end   
   
   private
   def generate_tokbox_session_id
     if Rails.env.production?
       self.tokbox_session_id = (TokboxApi.instance.generate_session User.first.current_sign_in_ip).to_s
     else
       self.tokbox_session_id = TokboxApi.instance.get_session_for_camera_test
     end
   end
end