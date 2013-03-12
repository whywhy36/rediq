require 'redis'

module Rediq
  module RedisHelper
    def connect_to_redis(redis_connection_opts = {:host => '127.0.0.1', :port => 6379})
      Redis.new(redis_connection_opts)
    end
  end
end
