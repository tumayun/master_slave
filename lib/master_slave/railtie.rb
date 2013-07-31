module MasterSlave
  class Railtie < Rails::Railtie # :nodoc:

    config.after_initialize do
      if File.exist?(MasterSlave::Configuration.config_file)
        puts "\033[32mmaster_slave is on!\033[0m"
        ActiveRecord::Base.send :include, MasterSlave::Base
        MasterSlave::ConnectionHandler.setup
      else
        puts "\033[31mNo such file #{MasterSlave::Configuration.config_file}\033[0m"
        puts "\033[31mPlease execute `rails g master_slave:config`\033[0m"
        puts "\033[31mmaster_slave is off!\033[0m"
      end
    end

    generators do
      require File.join(__dir__, '../', 'rails/generators/config_generator')
    end
  end
end
