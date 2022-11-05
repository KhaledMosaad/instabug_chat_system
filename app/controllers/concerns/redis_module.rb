require "redis"
module RedisModule
  def self.redis
    @redis = Redis.new(host: ENV["REDIS_HOST"],port: ENV["REDIS_PORT"],db: ENV["REDIS_DB"])
  end
  def self.get_new_number(token)
     num ||= redis.get(token).to_i
      if !num
        redis.set(token,1)
        num = 1
      else
        redis.incr(token)
        num+=1
      end
  end
end