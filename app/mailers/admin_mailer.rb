class AdminMailer < ActionMailer::Base
  #set in environment configuration files
  #default from: "from@example.com"

  def exception_notification_email(exp)
    @exception = exp
    mail :subject => "BTS: Exception occurred in Bug Summary Evaluation App!", :to => APP_CONFIG[:exception_notification_email], :cc => 'zeeshan.m.malik@gmail.com'
  end
end
