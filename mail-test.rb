require 'rubygems'
require 'mail'
require 'yaml'

CONFIG = YAML.load_file('./config.yml')

options = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => CONFIG['mail_domain'],
  :user_name => CONFIG['mail_username'],
  :password => CONFIG['mail_password'],
  :aurhentication => 'plain',
  :enable_starttls_auto => true }

Mail.defaults do
  delivery_method :smtp, options
end

Mail.deliver do
  from    CONFIG['mail_username']
  to      CONFIG['mail_username']
  subject 'Test Email'
  body    'This is a test email from ruby'
end
