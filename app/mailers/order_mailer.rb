class OrderMailer < ActionMailer::Base
  default from: "info@123dcamera.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Registered")
  end
  
  
end
