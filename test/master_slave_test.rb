require 'test_helper'

class MasterSlaveTest < ActiveSupport::TestCase

  test '.quite' do
    MasterSlave.remove_instance_variable :@quiet
    assert_equal MasterSlave.quiet, false
  end

  test '.quite=' do
    MasterSlave.quiet = true
    assert_equal MasterSlave.quiet, true
  end

  test '.config' do
    assert_instance_of MasterSlave::Configuration, MasterSlave.config
  end

  test '.setup' do
    MasterSlave::ConnectionHandler.stubs(:setup_connection)
    MasterSlave.setup!
  end
end
