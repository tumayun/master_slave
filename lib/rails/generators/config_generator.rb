require "rails/generators/named_base"
module MasterSlave
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      desc "Creates a MasterSlave configuration file at config/shards.yml"

      source_root File.expand_path('../templates', __FILE__)

      argument :database_name, type: :string, optional: true

      def app_name
        Rails::Application.subclasses.first.parent.to_s.underscore
      end

      def create_config_file
        template 'shards.yml', File.join(Rails.root, 'config', "shards.yml")
      end

      def mysql_socket
        @mysql_socket ||= [
          "/tmp/mysql.sock",                        # default
          "/var/run/mysqld/mysqld.sock",            # debian/gentoo
          "/var/tmp/mysql.sock",                    # freebsd
          "/var/lib/mysql/mysql.sock",              # fedora
          "/opt/local/lib/mysql/mysql.sock",        # fedora
          "/opt/local/var/run/mysqld/mysqld.sock",  # mac + darwinports + mysql
          "/opt/local/var/run/mysql4/mysqld.sock",  # mac + darwinports + mysql4
          "/opt/local/var/run/mysql5/mysqld.sock",  # mac + darwinports + mysql5
          "/opt/lampp/var/mysql/mysql.sock"         # xampp for linux
        ].find { |f| File.exist?(f) } unless RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
      end
    end
  end
end
