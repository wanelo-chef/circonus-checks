class Chef
  class Resource
    # Resource for the circonus_sidekiq_failed Chef provider
    #
    # circonus_sidekiq_failed 'my-app' do
    #   redis_db 2
    #   namespace 'app'
    #   target node.ipaddress
    # end
    #
    class CirconusSidekiqFailed < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :circonus_sidekiq_failed
        @provider = Chef::Provider::CirconusSidekiqFailed
        @action = :update
        @allowed_actions = [:update]
      end

      def name(arg = nil)
        set_or_return(:name, arg, kind_of: String)
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
