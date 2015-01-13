circonus-checks-cookbook
========================

Providers for common Circonus checks

## Usage

### postgres_locks

A gauge showing number of current locks of each type.

```ruby
include_recipe 'circonus-checks'

circonus_postgres_locks 'postgres' do
  database 'postgres'
  port 5432
  user 'postgres'
  password 'lajfaldsfasdj'
  target node.ipaddress
  broker 'my-broker'
end
```

* name - arbitrary
* port - defaults to 5432
* user - defaults to 'postgres'
* password - if not used, no password is included in connection string
* target - circonus target for postgres check
* broker - broker for graph creation

### rabbitmq_overview

Tracks metrics relating to overall RabbitMQ usage, including number
of connections, messages pending consumption and overall message count.
This configures a Circonus JSON check which hits the RabbitMQ overview API,
and depends on the RabbitMQ management plugin being installed.

```ruby
circonus_rabbitmq_overview 'my-app' do
  port 15672
  user 'guest'
  password 'guest'
  broker 'circonus.broker'
  target node.ipaddress
end
```

* name — arbitrary, just to make Chef resource unique
* port — the port to the admin API, which is different from the port used by AMQP
* user — a user with administrator privileges (required)
* password — (required)
* broker — broker for graph creation
* target — target for json check.

### sidekiq_queue

```ruby
include_recipe 'circonus-checks'

circonus_sidekiq_queue 'queue_name' do
  redis_db 2
  namespace 'app'
  target node.ipaddress
end
```

### sidekiq_failed

The `name` attribute of this check is arbitrary. It is
used to ensure that, if multiple sidekiq installations
are using the same redis host (perhaps with a different
db or namespace), Chef differentiates the providers.

```ruby
include_recipe 'circonus-checks'

circonus_sidekiq_failed node.name do
  redis_db 2
  namespace 'app'
  target node.ipaddress
end
```

### sidekiq_scheduled

The `name` attribute of this check is arbitrary. It is
used to ensure that, if multiple sidekiq installations
are using the same redis host (perhaps with a different
db or namespace), Chef differentiates the providers.

```ruby
include_recipe 'circonus-checks'

circonus_sidekiq_scheduled 'my-app' do
  redis_db 2
  namespace 'app'
  target node.ipaddress
end
```

## License and Authors

Author:: Wanelo, Inc. (<dev@wanelo.com>)
