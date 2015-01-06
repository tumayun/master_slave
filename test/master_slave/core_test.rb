require 'test_helper'

class CoreTest < ActiveSupport::TestCase

  def setup
    MasterSlave::Configuration.config_file = File.join(File.dirname(__FILE__), "..", "config", "shards.yml")
    ActiveRecord::Base.send :include, MasterSlave::Core
    MasterSlave.setup!
  end

  test '.slave_connection_names' do
    assert_equal ActiveRecord::Base.slave_connection_names, ['slave']
  end

  test '.slave' do
    assert_nil MasterSlave::RuntimeRegistry.current_slave_name
    assert_not MasterSlave::RuntimeRegistry.slave_block
    connection = ActiveRecord::Base.connection

    ActiveRecord::Base.slave do
      assert_equal MasterSlave::RuntimeRegistry.current_slave_name, 'slave'
      assert MasterSlave::RuntimeRegistry.slave_block
      assert_not_equal connection, ActiveRecord::Base.connection
    end

    assert_nil MasterSlave::RuntimeRegistry.current_slave_name
    assert_not MasterSlave::RuntimeRegistry.slave_block
    assert_equal connection, ActiveRecord::Base.connection
  end

  test '.slave with no slave name' do
    ActiveRecord::Base.stubs(:select_slave_connection_name).returns(nil)

    assert_nil MasterSlave::RuntimeRegistry.current_slave_name
    assert_not MasterSlave::RuntimeRegistry.slave_block
    connection = ActiveRecord::Base.connection

    ActiveRecord::Base.slave do
      assert_nil MasterSlave::RuntimeRegistry.current_slave_name
      assert_not MasterSlave::RuntimeRegistry.slave_block
      assert_equal connection, ActiveRecord::Base.connection
    end

    assert_nil MasterSlave::RuntimeRegistry.current_slave_name
    assert_not MasterSlave::RuntimeRegistry.slave_block
    assert_equal connection, ActiveRecord::Base.connection
  end

  test '.using' do
    assert_nil MasterSlave::RuntimeRegistry.current_slave_name
    assert_not MasterSlave::RuntimeRegistry.slave_block
    connection = ActiveRecord::Base.connection

    ActiveRecord::Base.using(:slave) do
      assert_equal MasterSlave::RuntimeRegistry.current_slave_name, 'slave'
      assert MasterSlave::RuntimeRegistry.slave_block
      assert_not_equal connection, ActiveRecord::Base.connection
    end

    assert_nil MasterSlave::RuntimeRegistry.current_slave_name
    assert_not MasterSlave::RuntimeRegistry.slave_block
    assert_equal connection, ActiveRecord::Base.connection
  end

  test '.using with slave name is not exist' do
    exception = assert_raises(RuntimeError) do
      ActiveRecord::Base.using('test') {}
    end

    assert_equal exception.message, 'The slave name is not exist.(test)'
  end
end
