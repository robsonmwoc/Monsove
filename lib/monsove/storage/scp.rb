module Monsove
  module Storage
    class SCP < Base
      attr_reader :server, :username, :ssh_key

      # Initialize the storage object.
      #
      # @option opts [String] :server   the server ip or domain name.
      # @option opts [String] :username the linux storage user name.
      # @option opts [String] :ssh_key  the public ssh key file.
      #
      # @return [Storage]
      def initialize(opts)
        @server   = opts['server']
        @username = opts['username']
        @ssh_key  = opts['ssh_key']
      end

      # Parse the given location into a bucket and a prefix.
      # This is not used by the SCP driver.
      #
      # @param [String] location the backup folder location in the server.
      #
      # @return [Hash]
      def parse_location(location)
        location = location.split('/')
        {:bucket => location.join('/'), :prefix => "backup"}
      end

      # Upload the given path to the server.
      #
      # @param [String] bucket the bucket where to store the archive in.
      # @param [String] key    the key where the archive is stored under.
      # @param [String] path   the path, where the archive is located.
      #
      # @return [Hash]
      def upload(bucket, key, path)
        # Make sure that there is the backup folder in the remote server
        create_bucket(bucket)

        Monsove.logger.info("Uploading archive to #{bucket}")

        # To scp is necessary to make a copy of the tmp file.
        backup_file = prepare_backup_file(key, path)

        cmd = "scp -i #{@ssh_key} #{backup_file} #{@username}@#{@server}:#{bucket}"

        system(cmd)

        File.delete("#{backup_file}")
      end

      # Download the backuped file
      def download(backup_file, job)
        Monsove.logger.info("Downloading archive from #{@server}:#{job['location']}")

        filesystem = Filesystem.new
        @path = filesystem.get_tmp_path

        system("mkdir -p #{@path}")

        cmd  = "scp -r -i #{@ssh_key} #{@username}@#{@server}:"
        cmd << "#{job['location']}/#{backup_file} #{@path}"

        system(cmd)
        raise "Error while downloading #{backup_file}" if $?.to_i != 0
      end

      # Remove old versions of a backup.
      #
      # @param [String] bucket the bucket where the archive is stored in.
      # @param [String] prefix the prefix where to look for outdated versions.
      # @param [Integer] versions number of versions to keep.
      #
      # @return [nil]
      def cleanup(bucket, prefix, versions)
      end

      def list(bucket)
        Monsove.logger.info("Getting list from #{@server}:#{bucket}")
        backup_list = `#{ssh( "ls -lh #{bucket}" )}`
        backup_list = backup_list.split("\n")[1..-1]

        puts "=========================================================="
        puts "Date       | Hour  | Size | Filename"
        backup_list.each do |item|
          item.match(/\s([0-9\.]{2,}[GBKM]?)/)
          size  = "#{$1}#{$2 || 'B'}"

          item.match(/(\d{4}\-\d{2}-\d{2})\s(\d{2}:\d{2})\s(backup.*)/)
          date     = $1
          hour     = $2
          filename = $3

          puts "#{date} | #{hour} | #{size} | #{filename}"
        end
        puts "=========================================================="
      end


      # TODO: Refactory the organization to elimate the job parameter.
      def restore(db, job, backup_file)
        Monsove.logger.info("Restoring from #{backup_file}")
        db_opts = db.get_opts(job['db'])

        filesystem = Filesystem.new
        filesystem.decompress("#{@path}/#{backup_file}")

        db.restore(db_opts, "#{@path}/#{db_opts[:db]}")
      end

      protected

      # Move the tmp file to the official backup name
      #
      # @param [String] key  the key where the archive is stored under.
      # @param [String] path the path, where the archive is located.
      #
      # @return [nil]
      def prepare_backup_file(key, path)
        backup_file = "#{Dir.tmpdir}/#{key}"
        system("cp #{path}.tar.bz2 #{backup_file}")
        backup_file
      end

      def create_bucket(bucket)
        Monsove.logger.info("Creating the bucket in #{bucket}")
        system( ssh("\"mkdir -p #{bucket}\"") )
      end

      def ssh(command)
        "ssh #{@server} -i #{@ssh_key} -l #{@username} #{command}"
      end

    end
  end
end