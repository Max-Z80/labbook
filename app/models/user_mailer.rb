class UserMailer < ActionMailer::Base
  
def contact_webmaster(message)
  recipients "dossiermax@yahoo.fr"
  from message.sender
  subject message.object
  sent_on Time.now
  body :message => message
  content_type "text/html"
end

def newuser(user)
  recipients user.email
  from "dossiermax@yahoo.fr"
  subject "Subscription to your Labbook"
  sent_on Time.now
  body :user => user
  content_type "text/html"
end
end
