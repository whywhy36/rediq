# RediQ

RediQ is one generic batch job processor based on Redis.

## Getting Started

build & install

```bash
[sudo] gem build rediq.gemspec
[sudo] gem install rediq-X.X.X.gem
```

## Basic Usage

```bash
rediq-server --help
Usage: rediq-server [options]
    -c, --config [FILE]              Specify config file
    -m, --mode [MODE]                Group run mode
```

There are two modes for rediq-server, debug and production(default). Debug mode is verbose, more logs will be output.
You should specify the config file of which format is yaml. One example of this configuration is like this

```
redis:
  name: "Redis"
  host: 127.0.0.1
  port: 6379

script:
  loadpath: "/path_to_scripts/scripts"
```

the loadpath tells the Rediq the path the job script located at. So rediq can find the specific job script according to
the script name.

In your Ruby code, create one rediq client

```ruby
rediq = Rediq.client.new(redis) # redis is one Redis client
```
or
```ruby
rediq = Rediq.client.new do |rediq|
  rediq.redis = redis
end
```

then we can use this client to create new job
```ruby
rediq.new_job(job_name, params)
```
job_name is one string that identities job script, params is one hash that we can defined ourselves as needed.

## Example

## TODO

 * complete README.md
 * add spec/test code
 * add Rake file and command
