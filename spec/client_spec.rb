require 'json'
require 'mock_redis'
require_relative '../lib/rediq/client'

describe 'Rediq Client' do

  before :all do
    @redis = MockRedis.new
    @rediq = Rediq::Client.new(@redis) do |rediq|
      rediq.queue = 'redis_q'
    end
    @job_name = 'job_name'
    @params_hash = {
        :hash_key => 'hash_val'
    }
  end

  it 'can pack job into json' do
    ret = @rediq.pack_job(@job_name, @params_hash)
    ret.should.is_a?(String)
    ret_hash = JSON.parse(ret, {:symbolize_names => true})
    ret_hash.key?(:id).should be_true
    ret_hash.key?(:start_time).should be_true
    ret_hash[:job_name].should == @job_name
    ret_hash[:params].should == @params_hash
  end

  it 'can push one new job to redis' do
    @rediq.new_job(@job_name, @params_hash)
    message = @redis.rpop('redis_q')
    msg_hash = JSON.parse(message, {:symbolize_names => true})

    msg_hash.key?(:id).should be_true
    msg_hash.key?(:start_time).should be_true
    msg_hash[:job_name].should == @job_name
    msg_hash[:params].should == @params_hash
  end

end