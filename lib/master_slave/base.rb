module MasterSlave
  module Base
    extend ActiveSupport::Concern

    included do
      cattr_accessor :slave_connection_names
      self.slave_connection_names = []

      class << self
        alias_method :connection_without_master_slave, :connection
        alias_method :connection, :connection_with_master_slave
      end
    end

    module ClassMethods

      def slave(&block)
        slave_name = select_slave_connection_name
        if slave_name.blank?
          block.call
        else
          with_slave(slave_name) do
            block.call
          end
        end
      end

      def using(slave_name, &block)
        with_slave(slave_name) do
          block.call
        end
      end

      def connection_with_master_slave
        slave_block        = MasterSlave::RuntimeRegistry.slave_block
        current_slave_name = MasterSlave::RuntimeRegistry.current_slave_name

        if defined?(Rails) && Rails.env.test?
          connection_without_master_slave
        elsif slave_block && current_slave_name
          pool_name  = MasterSlave::ConnectionHandler.connection_pool_name(current_slave_name)
          ar_proxy   = MasterSlave::ConnectionHandler::ArProxy.new(pool_name)
          ActiveRecord::Base.connection_handler.retrieve_connection(ar_proxy)
        else
          connection_without_master_slave
        end
      end

      protected

      def select_slave_connection_name
        ActiveRecord::Base.slave_connection_names[rand(ActiveRecord::Base.slave_connection_names.size)]
      end

      def with_slave(slave_name)
        slave_name = slave_name.to_s.strip
        raise "#{slave_name} not exist" unless ActiveRecord::Base.slave_connection_names.include?(slave_name)
        MasterSlave::RuntimeRegistry.current_slave_name = slave_name
        MasterSlave::RuntimeRegistry.slave_block        = true
        yield
      ensure
        MasterSlave::RuntimeRegistry.current_slave_name = nil
        MasterSlave::RuntimeRegistry.slave_block        = false
      end
    end
  end
end
