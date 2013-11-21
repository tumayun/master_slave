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
          # activerecord/lib/active_record/connection_adapters/abstract/connection_specification.rb +128
          ActiveRecord::Base.slave_connection_names << slave_name.to_s.strip
          configuration = MasterSlave.config.slave_config(slave_name).symbolize_keys

          resolver = ActiveRecord::Base::ConnectionSpecification::Resolver.new(configuration, nil)

          spec = resolver.spec

          unless ActiveRecord::Base.respond_to?(spec.adapter_method)
            raise AdapterNotFound, "database configuration specifies nonexistent #{spec.config[:adapter]} adapter"
          end

          ar_proxy = ArProxy.new(connection_pool_name(slave_name))

          # activerecord/lib/active_record/connection_adapters/abstract/connection_specification.rb +179
          # activerecord/lib/active_record/connection_adapters/abstract/connection_pool.rb +424
          # remove_connection 时会调用方法内部 ar_proxy.name
          ActiveRecord::Base.remove_connection(ar_proxy)

          # activerecord/lib/active_record/connection_adapters/abstract/connection_pool.rb +373
          # establish_connection 时，使用 ar_proxy.name
          ActiveRecord::Base.connection_handler.establish_connection ar_proxy.name, spec
        end
      end
    end
  end
end
