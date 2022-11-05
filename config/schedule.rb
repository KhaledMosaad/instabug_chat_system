
set :environment, :development
set :output, 'log/cron.log'
ENV.each { |k, v| env(k, v) }
every :minute do
  rake 'update_application_count'
end