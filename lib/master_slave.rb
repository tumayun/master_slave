require 'rails'
require 'active_support'
require 'active_record'
require 'master_slave/core'
require 'master_slave/configuration'
require 'master_slave/connection_handler'
require 'master_slave/runtime_registry'
require 'master_slave/version'
require 'master_slave/railtie'

module MasterSlave

  class << self
    def config
      @config ||= MasterSlave::Configuration.new
    end

    def quiet
      return @quiet if defined?(@quiet)
      @quiet = false
    end

    def quiet=(value)
      @quiet = !!value
    end

    def setup!
      MasterSlave::ConnectionHandler.setup_connection
    end
  end
end
