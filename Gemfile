source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.4"

gem "mysql2", "~> 0.5"

gem "puma", "~> 5.0"

gem 'bunny', '>= 2.9.2'

gem 'elasticsearch-model'

gem 'whenever', require: false

gem 'sneakers'

gem 'connection_pool'

gem 'redis-rails'

gem 'redis'

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

