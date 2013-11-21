module MasterSlave
  class Railtie < Rails::Railtie # :nodoc:

    config.after_initialize do
      if File.exist?(MasterSlave::Configuration.config_file)
        Rails.logger.info "\033[32mmaster_slave is on!\033[0m"
        ActiveRecord::Base.send :include, MasterSlave::Base
        MasterSlave::ConnectionHandler.setup
      else
        Rails.logger.error "\033[31mNo such file #{MasterSlave::Configuration.config_file}\033[0m"
        Rails.logger.error "\033[31mPlease execute `rails g master_slave:config`\033[0m"
        Rails.logger.error "\033[31mmaster_slave is off!\033[0m"
      end
    end

    generators do
      require File.expand_path('../../rails/generators/config_generator', __FILE__)
    end
  end
end
