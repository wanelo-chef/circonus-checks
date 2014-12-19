class Chef
  class Provider
    # Provider for the circonus_sidekiq_failed Chef provider
    #
    # circonus_sidekiq_failed 'my-app' do
    #   redis_db 2
    #   namespace 'app'
    #   target node.ipaddress
    # end
    #
    class CirconusSidekiqFailed < Chef::Provider::LWRPBase
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
        key = queue_key
        circonus_check_bundle bundle_name do
          type 'redis'
          config 'dbindex' => new_resource.redis_db,
                 'command' => "get #{key}"
          target new_resource.target
        end
      end

      def configure_metrics
        bundle = bundle_name
        circonus_metric queue_key do
          type :numeric
          check_bundle bundle
        end
      end

      def bundle_name
        'sidekiq-failed-jobs - %s - %s' % [
          new_resource.name,
          node.name
        ]
      end

      def queue_key
        '%s:stat:failed' % new_resource.namespace
      end
    end
  end
end
