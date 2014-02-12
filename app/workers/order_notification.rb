
class OrderNotification
  @queue = :order_notifications_queue
  def self.perform(notification_type, order_id)
  	order = Order.find(order_id)
		OrderMailer.send(notification_type, order).deliver
  end
end


