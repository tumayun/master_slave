module MasterSlave
  class ConnectionHandler

    class ArProxy
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    class << self

      def setup
        setup_connection
      end

      def connection_pool_name(slave_name)
        "master_slave_#{slave_name.to_s.strip}"
      end

      protected

      def setup_connection
        ActiveRecord::Base.slave_connection_names ||= []
        MasterSlave.config.slave_names.each do |slave_name|
          ActiveRecord::Base.slave_connection_names << slave_name.to_s.strip
          spec = MasterSlave.config.slave_config(slave_name).symbolize_keys

          resolver = ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.new spec, spec
          spec = resolver.spec

          unless ActiveRecord::Base.respond_to?(spec.adapter_method)
            raise AdapterNotFound, "database configuration specifies nonexistent #{spec.config[:adapter]} adapter"
          end

          ar_proxy = ArProxy.new(connection_pool_name(slave_name))
          ActiveRecord::Base.remove_connection(ar_proxy)
          ActiveRecord::Base.connection_handler.establish_connection ar_proxy, spec
        end
      end
    end
  end
end
