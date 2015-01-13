class Chef
  class Provider
    # Provider for the circonus_rabbitmq_overview Chef provider
    #
    # circonus_rabbitmq_overview 'my-app' do
    #   port 15672
    #   user 'guest'
    #   password 'guest'
    #   broker 'circonus.broker'
    #   target node.ipaddress
    # end
    #
    class CirconusRabbitmqOverview < Chef::Provider::LWRPBase
      GAUGES = { l: %w(queue_totals`messages
                       queue_totals`messages_ready
                       queue_totals`messages_unacknowledged),
                 r: %w(object_totals`connections) }.freeze

      COUNTERS = { l: %w(
        message_stats`ack
        message_stats`deliver
        message_stats`publish
        message_stats`redeliver) }.freeze

      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
      end

      def action_update
        run_context.include_recipe 'circonus'
        configure_check_bundle
        configure_metrics
        configure_graphs
        configure_graph_gauges
        configure_graph_counters
      end

      private

      def configure_check_bundle
        circonus_check_bundle new_resource.bundle_name do
          type 'json'
          config 'auth_methods' => 'basic',
                 'auth_user' => new_resource.user,
                 'auth_password' => new_resource.password,
                 'port' => new_resource.port,
                 'url' => 'http://%[target_ip]/api/overview'
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

      def configure_graph_gauges
        GAUGES.each do |side, metrics|
          metrics.each do |metric|
            circonus_graph_datapoint metric do
              graph new_resource.graph_name
              metric metric
              derive :gauge
              axis side
              broker new_resource.broker
            end
          end
        end
      end

      def configure_graph_counters
        COUNTERS.each do |side, metrics|
          metrics.each do |metric|
            circonus_graph_datapoint metric do
              graph new_resource.graph_name
              metric metric
              derive :counter
              axis side
              broker new_resource.broker
            end
          end
        end
      end

      def configure_metrics
        (GAUGES.values + COUNTERS.values).flatten.each do |metric|
          circonus_metric metric do
            type :numeric
            check_bundle new_resource.bundle_name
          end
        end
      end
    end
  end
end
