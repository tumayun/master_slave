module MasterSlave
  class Railtie < Rails::Railtie # :nodoc:

    config.after_initialize do
      if File.exist?(MasterSlave::Configuration.config_file)
        puts "\033[32mmaster_slave is on!\033[0m" unless MasterSlave.quiet
        ActiveRecord::Base.send :include, MasterSlave::Core
        MasterSlave.setup!
      elsif !MasterSlave.quiet
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
