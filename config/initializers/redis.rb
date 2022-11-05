pool_size = 5
redis = ConnectionPool.new(size: pool_size) do
  Redis.new(host: ENV["REDIS_HOST"], port: ENV["REDIS_PORT"],db:ENV["REDIS_DB"])
end
