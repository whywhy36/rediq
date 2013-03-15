require 'securerandom'
require 'json'
require_relative '../rediq/ext/redis_helper'
require_relative '../rediq/group/const'

module Rediq
  class Client
    include RedisHelper

    attr_accessor :redis, :queue

    def initialize(redis=nil)
      @redis = redis
      @queue = Rediq::REDIQ_QUEUE
      yield self if block_given?
    end

    def new_job(job_name, params)
      job_info = pack_job(job_name, params)
      redis.lpush(queue, job_info)
    end

    def pack_job(job_name, params)
      {
          :id         => SecureRandom.uuid,
          :job_name   => job_name,
          :params     => params,
          :start_time => Time.now.to_i
      }.to_json
    end
  end
end