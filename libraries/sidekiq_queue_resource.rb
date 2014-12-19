class Chef
  class Resource
    # Resource for the circonus_sidekiq_queue Chef provider
    #
    # circonus_sidekiq_queue 'queue_name' do
    #   redis_db 2
    #   namespace 'app'
    #   target node.ipaddress
    # end
    #
    class CirconusSidekiqQueue < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :circonus_sidekiq_queue
        @provider = Chef::Provider::CirconusSidekiqQueue
        @action = :update
        @allowed_actions = [:update, :delete]
      end

      def queue(arg = nil)
        set_or_return(:queue, arg, kind_of: String, name_attribute: true, required: true)
      end

      def redis_db(arg = nil)
        set_or_return(:redis_db, arg, kind_of: Integer, default: 1)
      end

      def namespace(arg = nil)
        set_or_return(:namespace, arg, kind_of: String, required: true)
      end

      def target(arg = nil)
        set_or_return(:target, arg, kind_of: String, required: true)
      end
    end
  end
end
