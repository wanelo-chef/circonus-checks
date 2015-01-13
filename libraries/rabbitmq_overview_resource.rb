class Chef
  class Resource
    # Resource for the circonus_rabbitmq_overview Chef provider
    #
    # circonus_rabbitmq_overview 'my-app' do
    #   port 15672
    #   user 'guest'
    #   password 'guest'
    #   broker 'circonus.broker'
    #   target node.ipaddress
    # end
    #
    class CirconusRabbitmqOverview < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :circonus_rabbitmq_overview
        @provider = Chef::Provider::CirconusRabbitmqOverview
        @action = :update
        @allowed_actions = [:update]
      end

      def name(arg = nil)
        set_or_return(:name, arg, kind_of: String)
      end

      def broker(arg = nil)
        set_or_return(:broker, arg, kind_of: String, required: true)
      end

      def port(arg = nil)
        set_or_return(:port, arg, kind_of: Integer, default: 15672) # rubocop:disable Style/NumericLiterals
      end

      def user(arg = nil)
        set_or_return(:user, arg, kind_of: String, required: true)
      end

      def password(arg = nil)
        set_or_return(:password, arg, kind_of: String, required: true)
      end

      def target(arg = nil)
        set_or_return(:target, arg, kind_of: String, required: true)
      end

      def bundle_name
        "rabbitmq overview - #{node.name}"
      end

      def graph_name
        "#{node.name} - rabbitmq overview"
      end
    end
  end
end
