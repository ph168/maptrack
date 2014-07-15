source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.0.2'
gem 'activesupport', '4.0.2'

gem 'angular_rails_csrf'

# Rails 4
gem 'protected_attributes'

group :development, :test do
  gem 'sqlite3'
  gem 'rake'
end
group :test do
  gem 'webmock'
end
group :production do
  gem 'pg'
  gem 'rails_serve_static_assets'
end

gem 'taps'

gem 'mongoid', github: 'mongoid/mongoid'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.1'

  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'

gem 'devise'

gem 'nominatim', :git => 'https://github.com/ph168/nominatim.git'
