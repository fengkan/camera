#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.gmail.com",
#  :port => 587,
#  :domain => "123dcamera.com",
#  :user_name => "fengkan",
#  :password => "password",
#  :authentication => "plain",
#  :enable_starttls_auto => true
#}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"

