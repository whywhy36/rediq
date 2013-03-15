$LOAD_PATH.unshift File.dirname(__FILE__)

require 'eventmachine'
require 'logger'
require 'optparse'
require 'yaml'
YAML::ENGINE.yamler = "syck"

def require_dir(dir)
  dir_path = "#{File.dirname(__FILE__)}/#{dir}"
  Dir.open(dir_path).each do |file|
    next if file =~ /^\./
    require "#{dir_path}/#{file}"
  end
end

%w[group ext].each do |dir|
  require_dir dir
end

options = {:config_file => "#{File.dirname(__FILE__)}/../../rediq.yml", :mode => "PRODUCTION"}

MODE = %[DEBUG PRODUCTION]

DEBUG_LEVEL = {
    "DEBUG" => Logger::DEBUG,
    "PRODUCTION" => Logger::INFO
}

OptionParser.new do |opts|
  opts.banner = 'Usage: rediq-server [options]'

  opts.on('-c', '--config [FILE]', String, 'Specify config file') do |f|
    options[:config_file] = f
  end

  opts.on('-m', '--mode [MODE]', String, 'Group run mode') do |m|
    m.upcase!
    options[:mode] = m if MODE.include?(m)
  end
end.parse!

module Rediq
  class << self
    attr_accessor :dispatcher, :max_worker_num, :current_worker_num, :logger, :options

    def do_init(config, opts)
      @options = opts
      @current_worker_num = 0
      set_up_trap
      set_up_logger
      Rediq::EnvChecker.init
      @max_worker_num = Rediq::EnvChecker.processor_count || 3
      @logger.debug "Max Worker Number set to #{@max_worker_num}"
      @dispatcher = Rediq::Dispatcher.new(config)
    end

    def set_up_trap
      trap('CLD') do
        @current_worker_num -= 1
      end
    end

    def set_up_logger
      @logger = Logger.new(STDOUT)
      @logger.level = DEBUG_LEVEL[options[:mode]]
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] #{severity} -- : #{msg}\n"
      end
    end

    def run
      EventMachine.run do
        EM.add_periodic_timer(5) { dispatcher.dispatch }
      end
    end
  end
end

puts "Loading configuration from #{options[:config_file]}"
config = YAML.load_file(options[:config_file])
puts config.inspect
Rediq.do_init(config, options)
Rediq.run
