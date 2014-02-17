class UserMailer < ActionMailer::Base
  default from: "info@123dcamera.com"

  def reset_password(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "reset password")
  end
  
  
end
