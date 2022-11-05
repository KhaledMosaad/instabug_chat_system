#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle install && bundle exec rake db:create && bundle exec rake db:migrate && rails routes && rake sneakers:run WORKERS = MessageCreateWorker,ChatCreateWorker && bundle exec whenever --update-crontab && service cron start && bundle exec rails s -b 0.0.0.0 