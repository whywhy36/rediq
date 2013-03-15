require 'json'

require_relative '../ext/redis_helper'
require_relative 'worker'
require_relative 'script_runner'
require_relative 'const'

module Rediq
  class Dispatcher
    include RedisHelper

    attr_accessor :redis, :queue, :pending, :config, :logger

    def initialize(configuration)
      @config = configuration
      @redis = connect_to_redis(configuration['redis'])
      @queue = Rediq::REDIQ_QUEUE
      @pending = Rediq::REDIQ_PENDING
      @logger = Rediq.logger
      yield self if block_given?
    end

    def dispatch
      loop do
        return unless Rediq.current_worker_num < Rediq.max_worker_num

        job = redis.lindex(pending, -1)
        unless job.nil?
          Rediq.current_worker_num += 1
          fork do
            s_runner = ScriptRunner.new(config['script'], logger)
            worker = Worker.new(s_runner) do |me|
               logger.debug 'worker started ...'
            end
            job_hash = JSON.parse(job)
            ret, error_status = worker.handle(job_hash)
            if ret
              logger.debug 'worker finished job, dying'
            else
              logger.debug "worker failed to do the job, and the error status is #{error_status}"
            end
          end
        end
        redis.rpop(pending)
        redis.brpoplpush(queue, pending, 0)
      end
    end
  end
end
