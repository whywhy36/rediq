module Rediq
  class ScriptRunner
    attr_accessor :path, :logger

    def initialize(config)
      @path = config['loadpath']
      @logger = Rediq.logger
    end

    def handle(job)
      job_name, job_params = extract_job_info job
      logger.debug "the path is #{path} and the job name is #{job_name}"
      script_path = File.join(path, job_name)
      run_script_with_params(script_path, job_params)
    end

    def extract_job_info(job)
      job_name   = job['job_name']
      job_params = job['job_params']
      [job_name, job_params]
    end

    def run_script_with_params(script, script_params)
      logger.debug script
      ret = system("#{script}")
      {:ret => ret, :error_status => $?}
    end
  end
end