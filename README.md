circonus-checks-cookbook
========================

Providers for common Circonus checks

## Usage

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
