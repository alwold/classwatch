source 'https://rubygems.org'

gem 'rails', '3.2.1'

gem 'ruby-hmac'
platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jruby-openssl'
end
platforms :ruby do
  gem 'sqlite3'
  gem 'pg'
end
gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'

  gem 'bootstrap-sass'
end

gem 'jquery-rails'

group :development do
  platforms :jruby do
    gem 'ruby-debug'
  end
  platforms :ruby do
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
end

gem 'devise'
gem 'warbler'
gem 'dynamic_form'
gem 'stripe'
gem 'asu-schedule-scraper', :git => 'git://github.com/alwold/asu-schedule-scraper.git', :require => 'asu_schedule_scraper'
gem 'twilio-ruby'