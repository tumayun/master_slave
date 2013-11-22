# encoding: utf-8
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
          configuration = MasterSlave.config.slave_config(slave_name).symbolize_keys
          unless configuration.key?(:adapter) then raise AdapterNotSpecified, "database configuration does not specify adapter" end

          adapter_method = "#{configuration[:adapter]}_connection"
          unless ActiveRecord::Base.respond_to?(adapter_method)
            raise AdapterNotFound, "database configuration specifies nonexistent #{spec.config[:adapter]} adapter"
          end

          # remove_connection 时会调用方法内部 ar_proxy.name
          ar_proxy = ArProxy.new(connection_pool_name(slave_name))
          ActiveRecord::Base.remove_connection(ar_proxy)

          spec = ActiveRecord::Base::ConnectionSpecification.new(configuration, adapter_method)
          ActiveRecord::Base.connection_handler.establish_connection spec
        end
      end
    end
  end
end
