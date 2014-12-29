class Chef
  class Provider
    # Provider for the circonus_postgres_locks Chef provider
    #
    # circonus_postgres_locks 'my-app' do
    #   database 'my-database'
    #   port 5432
    #   user 'postgres'
    #   password '3245jlkjdsf32'
    #   target node.ipaddress
    # end
    #
    class CirconusPostgresLocks < Chef::Provider::LWRPBase
      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
      end

      def action_update
        run_context.include_recipe 'circonus'
        configure_check_bundle
        configure_metrics
      end

      private

      def configure_check_bundle
        dsn = connection_string
        circonus_check_bundle bundle_name do
          type 'postgres'
          config 'dsn' => dsn,
                 'sql' => 'select mode, sum(1) as gauge from pg_locks group by mode;'
          target new_resource.target
        end
      end

      def configure_metrics
        bundle = bundle_name
        %w(AccessExclusiveLock`gauge
           AccessShareLock`gauge
           ExclusiveLock`gauge
           RowExclusiveLock`gauge
           RowShareLock`gauge
           ShareLock`gauge
           ShareUpdateExclusiveLock`gauge).each do |lock|
          circonus_metric lock do
            type :numeric
            check_bundle bundle
          end
        end
      end

      def bundle_name
        "postgres-locks - #{node.name}"
      end

      def connection_string
        ['host=%[target_ip]'].tap do |dsn|
          dsn << "port=#{new_resource.port}"
          dsn << "user=#{new_resource.user}"
          dsn << "password=#{new_resource.password}" if new_resource.password
          dsn << "dbname=#{new_resource.database}"
        end.join(' ')
      end
    end
  end
end
