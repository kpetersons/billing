class ActivationMailer < ActionMailer::Base
  default :from => "admin@petpat.lv"
  
 def activation_email(user, host)
    @user = user
    @host = host
    mail(:to => user.email, :subject => "Activation email")    
  end  
end
