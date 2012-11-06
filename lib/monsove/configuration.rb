module Monsove

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :storage

    # For scp
    config_accessor :server
    config_accessor :username
    config_accessor :ssh_key

    # For fog based
    config_accessor :access_id
    config_accessor :secret_key

    # General
    config_accessor :location
    config_accessor :versions
    config_accessor :database
  end

  class << self

    # Parse YAML configuration file.
    #
    # @param [String] config_file the path of the configuration file.
    #
    # @return [Configuration]
    def load_config(config_file)
      YAML.load(File.read(config_file))
      # TODO: Transform the config file to Configuration object
    rescue Errno::ENOENT
      Monsove.logger.error("Could not find config file file at #{ARGV[0]}")
      exit
    rescue ArgumentError => e
      Monsove.logger.error("Could not parse config file #{ARGV[0]} - #{e}")
      exit
    end
    
    def configure(&block)
      yield @config ||= Configuration.new
    end

    def config
      @config
    end
  end


  configure do |config|
    # config.storage = Monsove::Storage::S3
  end

end
