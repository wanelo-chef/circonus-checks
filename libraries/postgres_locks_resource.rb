class Chef
  class Resource
    # Resource for the circonus_postgres_locks Chef provider
    #
    # circonus_postgres_locks 'my-app' do
    #   database 'my-database'
    #   port 5432
    #   user 'postgres'
    #   password '3245jlkjdsf32'
    #   target node.ipaddress
    # end
    #
    class CirconusPostgresLocks < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :circonus_postgres_locks
        @provider = Chef::Provider::CirconusPostgresLocks
        @action = :update
        @allowed_actions = [:update]
      end

      def name(arg = nil)
        set_or_return(:name, arg, kind_of: String)
      end

      def database(arg = nil)
        set_or_return(:database, arg, kind_of: String, required: true)
      end

      def port(arg = nil)
        set_or_return(:port, arg, kind_of: Integer, default: 5432)
      end

      def user(arg = nil)
        set_or_return(:user, arg, kind_of: String, default: 'postgres')
      end

      def password(arg = nil)
        set_or_return(:password, arg, kind_of: String)
      end

      def target(arg = nil)
        set_or_return(:target, arg, kind_of: String, required: true)
      end
    end
  end
end
