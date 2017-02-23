# Monitoring

Vestorly's `monitoring` gem provides standard interfaces for writing,
performing, and reporting application-level checks. The library has no external
dependencies and it can be used in any ruby application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monitoring', git: 'https://github.com/vestorly/monitoring.git
```

And then execute:

    $ bundle

## Basics

There are two central concepts over which the library is built: `probes` and
`handlers`.  A `Probe` is simply a chunk of monitoring code; it requires a name
and it must adhere to a few conventions that will be explained in the
following sections. A `Probe` can be declared as it follows:

```ruby
Monitoring.add(:redis) do
  $redis.connected?
end

Monitoring.add(:google_dns) do
  system('nc -z 8.8.8.8 53')
end
```

Every `Probe` execution generates a `Result` object including basic information
about the test. Conversely, a `Handler` takes a `Result` object and does something
useful with it. As an example, a `Handler` could log results or report
it using an error tracking tool such as *Sentry* or *Appsignal*.

## Built-in handlers

The `monitoring` gem comes with a few built-in handlers:

Name | Purpose
--- | ---
`Handlers::Logger` | Write results to a log sink using either `Rails.logger` or `Logger`. **Enabled by default.**
`Handlers::FileReporter` | Write aggregate results in `JSON` format to the file specified in `Monitoring.configuration.output_file`. **Enabled by default.**
`Handlers::SentryReporter` | Report `Sentry` errors using the `raven` gem.
`Handlers::SlackNotifier` | Send Slack notifications.
`Handlers::Poster` | Perform HTTP POST request with a custom payload.

#### Enabling handlers

`handlers` can be enabled as it follows:

```ruby
Monitoring.configure do |c|
  c.add_handler :sentry, Monitoring::Handler::SentryReporter.new
  c.add_handler :slack, Monitoring::Handler::SlackNotifier.new(ENV.fetch(:SLACK_WEBHOOK))
end
```

By default, all `probes` will have their results processed by all *enabled*
`handlers`.  If you want to specify a custom set of handlers to be run after a
probe execution finishes, you can use the `handle_with` option:

```ruby
Monitoring.add(:sendgrid, handle_with: [:logger, :slack]) do
    ...
end
```

## Probing Evaluation

All probes have their return values coerced into `Result` objects:

* `nil`, `false` and `''` are coerced into a `FAILURE` result;
* exceptions are captured and turned into a `FAILURE` as well;
* `String` objects are coerced into a `SUCCESS` result and their values are used
  as the message;
* pairs like `[true|false, 'custom message']` are also accepted;

These evaluation rules enable `SUCCESS/FAILURE` checks to be performed while
conveying useful information:

```ruby
Monitoring.add(:sidekiq_queue) do
  queue = Sidekiq::Queue.all.first
  [queue.size < 100, "Queue size: #{queue.size}"]
end
```

## Configuration

Here are some useful configuration parameters:

```ruby
Monitoring.configure do |c|
  c.application_name 'my_application_name'
  c.timeout = 10
  c.output_file = '/var/log/monitoring.json'
end
```

## Execution

It is the client responsibility to periodically run the tests (by using a task
scheduling tool). The entry point for running all probes is `Monitoring.run`. For
your convenience, a `rake monitoring:run` task is provided.

It is worth mentioning that all probes run concurrently in separate threads, so
keep in mind any thread-safety issues.

## Monitoring endpoint

You can easily enable a monitoring endpoint in your application by adding the
following code to your `routes.rb` file:

```ruby
get 'monitoring', to: Monitoring::Route
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Vestorly/monitoring.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
