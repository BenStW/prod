# == Schema Information
#
# Table name: interested_users
#
#  id         :integer         not null, primary key
#  email       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class InterestedUser < ActiveRecord::Base
  # model InterestedUser is not needed anymore, but should be kept to hold the data in the database
  
# validates :email, :presence => true
# validates_format_of :email,
#   :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  
end
