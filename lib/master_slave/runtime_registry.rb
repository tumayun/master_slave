begin
  require 'active_support/per_thread_registry'
rescue LoadError
  module ActiveSupport
    module PerThreadRegistry
      protected

        def method_missing(name, *args, &block) # :nodoc:
          # Caches the method definition as a singleton method of the receiver.
          define_singleton_method(name) do |*a, &b|
            per_thread_registry_instance.public_send(name, *a, &b)
          end

          send(name, *args, &block)
        end

      private

        def per_thread_registry_instance
          Thread.current[name] ||= new
        end
    end
  end
end

module MasterSlave
  class RuntimeRegistry
    extend ActiveSupport::PerThreadRegistry

    attr_accessor :slave_block, :current_slave_name
  end
end
