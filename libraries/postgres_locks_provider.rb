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
      LOCKS = %w(AccessExclusiveLock`gauge
                 AccessShareLock`gauge
                 ExclusiveLock`gauge
                 RowExclusiveLock`gauge
                 RowShareLock`gauge
                 ShareLock`gauge
                 ShareUpdateExclusiveLock`gauge).freeze

      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
      end

      def action_update
        run_context.include_recipe 'circonus'
        configure_check_bundle
        configure_metrics
        configure_graphs
        configure_graph_metrics
      end

      private

      def configure_check_bundle
        circonus_check_bundle new_resource.bundle_name do
          type 'postgres'
          config 'dsn' => new_resource.connection_string,
                 'sql' => 'select mode, sum(1) as gauge from pg_locks group by mode;'
          target new_resource.target
        end
      end

      def configure_graphs
        circonus_graph new_resource.graph_name do
          style :line
          min_left_y 0
          min_right_y 0
        end
      end

      def configure_graph_metrics
        LOCKS.each do |lock|
          circonus_graph_datapoint lock do
            graph new_resource.graph_name
            metric lock
            derive :gauge
            axis :l
            broker new_resource.broker
          end
        end
      end

      def configure_metrics
        LOCKS.each do |lock|
          circonus_metric lock do
            type :numeric
            check_bundle new_resource.bundle_name
          end
        end
      end
    end
  end
end
