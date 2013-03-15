# RediQ

## What is RediQ

RediQ is one generic batch job processor based on Redis. You can easily integrate Rediq into your own application.
Any executable script compatible with *nix can be scheduled by RediQ, you just focus on application logic or batch job
logic without worrying about the resource exhausted due to unscheduled job. Suppose you are developing one web
application and you want this app can run some job background, you can use the language-specific framework (like resque
in Ruby) to achieve the purpose. Using Rediq, just split up the batch task, write it in your favorite or most suitable
language, and then, leave it to RediQ.

## Getting Started

build & install

```bash
[sudo] gem build rediq.gemspec
[sudo] gem install rediq-X.X.X.gem
```

or use Gemfile
```ruby
gem 'redis', :github => 'whywhy36/rediq'
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
