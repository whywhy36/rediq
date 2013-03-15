require 'json'

module Rediq
  class ScriptRunner
    attr_accessor :path, :logger

    def initialize(config, logger)
      @path = config['loadpath']
      @logger = logger
      yield self if block_given?
    end

    def handle(job)
      job_name, job_params = extract_job_info job
      logger.debug "the path is #{path} and the job name is #{job_name}"
      script_path = File.join(path, job_name)
      run_script_with_params(script_path, job_params)
    end

    def extract_job_info(job)
      job_name   = job['job_name']
      job_params = job['params']
      [job_name, job_params]
    end

    def run_script_with_params(script, script_params)
      command = "#{script} '#{script_params.to_json}' "
      logger.debug "run command : #{command}"
      ret = system(command)
      {:ret => ret, :error_status => $?}
    end
  end
end