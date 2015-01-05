module MasterSlave

  def self.config
    @config ||= MasterSlave::Configuration.new
  end

  class Configuration
    cattr_accessor :config_file

    def initialize
      @content = load_config
    end

    def slave_names
      raise "#{Rails.env}'s slave config not exist" if @content.blank?
      @shard_names ||= @content.keys.sort
    end

    def slave_config(slave_name)
      @content[slave_name]
    end

    def self.config_file
      @@config_file ||= File.join(Rails.root, 'config', 'shards.yml')
    end

    private

    def load_config
      if File.exist?(self.class.config_file)
        hash_config = YAML.load(ERB.new(File.read(self.class.config_file)).result)
        HashWithIndifferentAccess.new(hash_config)[Rails.env]
      else
        {}
      end
    end
  end
end
