# == Schema Information
#
# Table name: friendships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  create     :string(255)
#  destroy    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validates :user, :friend, presence: true
end
