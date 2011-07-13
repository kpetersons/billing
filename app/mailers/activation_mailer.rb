class ActivationMailer < ActionMailer::Base
  default :from => "admin@petpat.lv"
  
 def activation_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Activation email")    
  end  
end
