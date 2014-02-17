
class UserNotification
  @queue = :user_notifications_queue
  def self.perform(notification_type, user_id)
  	user = User.find(user_id)
		UserMailer.send(notification_type, user).deliver
  end
end


