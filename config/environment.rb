ENV['RAILS_ENV'] ||= 'production'
#ENV['RAILS_ENV'] ||= 'development'

#RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

if ENV['RAILS_ENV'] == 'production'
	ENV['GEM_PATH'] = '/home/rapolo/.gems' + ':/usr/lib/ruby/gems/1.8'
end

Rails::Initializer.run do |config|
  config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  config.time_zone = 'Brasilia'
  config.gem "brI18n", :version=>'2.1.10'
end

require 'extend_string'
require 'open-uri'
require 'digest/md5'
require 'brI18n'
require 'brstring'
require 'twitter'
require 'torrent_info'
require 'domainatrix'

ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.smtp_settings = {
  :address => "mail.baixogavea.com",
  :domain => "baixogavea.com",
  :port => 25,
  :authentication => :login,
  :user_name => "robo",
  :password => "12senhaemail13",
}
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.perform_deliveries = true
