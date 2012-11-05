module Monsove
  module Storage
    class Base
      include AbstractInterface

      # Initialize the storage object
      #
      # @param [String] engine the storage engine name
      # @param [Hash] opts the storage configuration
      #
      # @return Storage::Base SubClass
      def self.get_instance(engine, opts)
        case engine
        when "s3"
          AWS.new(opts)
        when "scp"
          SCP.new(opts)
        end
      end

      def parse_location(location)
        Base.not_implemented(self)
      end

      def upload(bucket, key, path)
        Base.not_implemented(self)
      end

      def download(backup_file)
        Base.not_implemented(self)
      end

      def cleanup(bucket, prefix, versions)
        Base.not_implemented(self)
      end

      def list()
        Base.not_implemented(self)
      end

      def restore()
        Base.not_implemented(self)
      end
    end
  end
end