# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
 config.action_mailer.raise_delivery_errors = false

# no authentication required for the following SMTP server because the I go to internet with the IP 
# address which is a fix FREE IP address so no authentification. Depending on where the the labbook 
# will be hosted I will hae to change this.

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "",
  :port => 25,
  :domain => "",

}

