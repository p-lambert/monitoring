# Monitoring

Vestorly's `monitoring` gem provides a standard interface for writing, running,
and reporting application-level monitoring tests. The library has no external
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
`handlers`.  A `Probe` is simply a chunk of monitoring code. It requires a name
and it has to adhere to a few conventions that will be explained in the
following sections. A `Probe` can be declared as it follows:

```ruby
Monitoring.add(:redis) do
  $redis.alive?
end
```

When a `Probe` runs, it yields a `Result` object including basic information
about the test: the probe name, the execution result (`SUCCESS` or `FAILURE`)
and an optional message.

On the other hand, a `Handler` takes a `Result` object and does something
useful with it. As an example, a `Handler` could log results or report
it using an error tracking tool such as *Sentry* or *Appsignal*.

## Built-in handlers

The `monitoring` gem comes with a few built-in handlers:

Name | Purpose
--- | ---
`Handlers::Logger` | Writes the results to a given sink using either `Rails.logger` or `Logger`. Enabled by default.
`Handlers::FileReporter` | Writes the aggregate results in `JSON` format to the file specified in `Monitoring.configuration.output_file`. Enabled by default.
`Handlers::SentryReporter` | Report `Sentry` errors using the `raven` gem.
`Handlers::SlackNotifier` | Sends Slack notifications.
`Handlers::Poster` | Sends a HTTP POST request with a custom payload.

#### Enabling handlers

`Handlers` can be enabled as it follows:

```ruby
Monitoring.configure do |c|
  c.add_handler :sentry, Monitoring::Handler::SentryReporter.new
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

It is the client responsibility to periodically run the tests (using a task
scheduling tool). The entrypoint for running all probes is `Monitoring.run`. For
your convenience, a `rake monitoring:run` task is provided.

It is worth mentioning that all probes run concurrently in separate threads, so
keep in mind any thread-safety issues.

## Bonus

You can easily enable a monitoring endpoint in your application by adding the
following code to your `routes.rb` file:

```ruby
get 'monitoring', to: Monitoring::Route
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vestorly/monitoring.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
