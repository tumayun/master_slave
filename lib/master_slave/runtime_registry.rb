require 'active_support/per_thread_registry'
module MasterSlave
  class RuntimeRegistry
    extend ActiveSupport::PerThreadRegistry

    attr_accessor :slave_block, :current_slave_name
  end
end
