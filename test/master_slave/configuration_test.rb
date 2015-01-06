require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  test '.config_file' do
    MasterSlave::Configuration.remove_class_variable :@@config_file
    assert_equal MasterSlave::Configuration.config_file, File.join(Rails.root, 'config', 'shards.yml')
  end

  test '.config_file=' do
    MasterSlave::Configuration.config_file = File.join(File.dirname(__FILE__), "..", "config", "shards.yml")
    assert_equal MasterSlave::Configuration.config_file, File.join(File.dirname(__FILE__), "..", "config", "shards.yml")
  end

  test '#slave_names' do
    MasterSlave::Configuration.config_file = File.join(File.dirname(__FILE__), "..", "config", "shards.yml")
    config = MasterSlave::Configuration.new
    assert_equal config.slave_names, ['slave']

    MasterSlave::Configuration.config_file = nil
    config = MasterSlave::Configuration.new
    exception = assert_raises(RuntimeError) { config.slave_names }
    assert_equal exception.message, "#{Rails.env}'s slave config is not exist"
  end

  test '#slave_config' do
    MasterSlave::Configuration.config_file = File.join(File.dirname(__FILE__), "..", "config", "shards.yml")
    config = MasterSlave::Configuration.new
    assert_equal config.slave_config('slave'),
      { "adapter" => "sqlite3", "pool" => 5, "timeout" => 5000, "database" => "db/test.sqlite3" }

    MasterSlave::Configuration.config_file = nil
    config = MasterSlave::Configuration.new
    assert_nil config.slave_config('slave')
  end
end
