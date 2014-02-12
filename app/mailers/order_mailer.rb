class OrderMailer < ActionMailer::Base
  default from: "info@123dcamera.com"

  def paid_notification(order)
    @order = order
    mail(:to => "<#{order.user.email}>", :subject => "Registered")
  end
  
  
end
