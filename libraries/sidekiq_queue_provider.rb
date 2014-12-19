class Chef
  class Provider
    # Resource for the circonus_sidekiq_queue Chef provider
    #
    # circonus_sidekiq_queue 'queue_name' do
    #   redis_db 2
    #   namespace 'app'
    #   target node.ipaddress
    # end
    #
    class CirconusSidekiqQueue < Chef::Provider::LWRPBase
      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.queue)
      end

      def action_update
        run_context.include_recipe 'circonus'
        configure_check_bundle
        configure_metrics
      end

      def action_delete
        run_context.include_recipe 'circonus'
        circonus_check_bundle bundle_name do
          action :delete
          type 'redis'
          target new_resource.target
        end
      end

      private

      def configure_check_bundle
        key = queue_key
        circonus_check_bundle bundle_name do
          type 'redis'
          config 'dbindex' => new_resource.redis_db,
                 'command' => "llen #{key}"
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
        'sidekiq-queue-%s - %s' % [
          new_resource.queue,
          node.name
        ]
      end

      def queue_key
        '%s:queue:%s' % [
          new_resource.namespace,
          new_resource.queue
        ]
      end
    end
  end
end
