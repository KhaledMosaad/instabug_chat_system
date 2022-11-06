
set :environment, :development
set :output, 'log/cron.log'
ENV.each { |k, v| env(k, v) }
every 45.minutes do
  rake 'update_application_count'
end