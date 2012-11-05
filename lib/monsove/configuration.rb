module Monsove
  class Configuration
    class << self

      # Parse YAML job configuration.
      #
      # @param [String] jobfile the path of the job configuration file.
      #
      # @return [Hash]
      def parse_jobfile(jobfile)
        YAML.load(File.read(jobfile))
      rescue Errno::ENOENT
        Monsove.logger.error("Could not find job file at #{ARGV[0]}")
        exit
      rescue ArgumentError => e
        Monsove.logger.error("Could not parse job file #{ARGV[0]} - #{e}")
        exit
      end
    end
  end
end