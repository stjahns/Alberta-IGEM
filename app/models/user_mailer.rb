class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end

  def reset_notification(user)
    setup_email(user)
    @subject  += 'Link to reset your password'
    @body[:url] = "#{SITE_URL}/reset/#{user.reset_code}"
  end

  def new_email_activation( email_observer  )
	user = email_observer.user
	setup_email(user)
	@subject += "Link to activate your new email for #{user.login} at Genomikon"
	@recipients = email_observer.email
	@body[:url] = "Please go to the link below to activate your new email.\nhttp://#{SITE_URL}/users/#{user.id}/new_email#{email_observer.key}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "admin@genomikon.ca"
      @subject     = "#{SITE_URL}"
      @sent_on     = Time.now
      @body[:user] = user
    end
end
