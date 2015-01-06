require 'test_helper'

class ConnectionHandlerTest < ActiveSupport::TestCase

  def setup
    MasterSlave::Configuration.config_file = File.join(File.dirname(__FILE__), "..", "config", "shards.yml")
    ActiveRecord::Base.send :include, MasterSlave::Core
  end

  test 'MasterSlave::ConnectionHandler::ArProxy' do
    ar_proxy = MasterSlave::ConnectionHandler::ArProxy.new('master_slave_slave')
    assert_equal ar_proxy.name, 'master_slave_slave'
  end

  test '.connection_pool_name' do
    assert_equal MasterSlave::ConnectionHandler.connection_pool_name('slave'), 'master_slave_slave'
  end

  test '.setup_connection' do
    ar_proxy = MasterSlave::ConnectionHandler::ArProxy.new(MasterSlave::ConnectionHandler.connection_pool_name('slave'))
    ActiveRecord::Base.remove_connection(ar_proxy)

    MasterSlave::ConnectionHandler.setup_connection
    assert_equal ActiveRecord::Base.slave_connection_names, ['slave']
    assert_includes ActiveRecord::Base.connection_handler.send(:owner_to_pool).keys,
      MasterSlave::ConnectionHandler.connection_pool_name('slave')
  end
end
