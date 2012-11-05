module Monsove
  class Backup

    # Public: Initialize the backup.
    #
    # config_file  - The yaml config file.
    #
    # Examples
    #
    #   Monsove::Backup.new('/path/to/monsove.yml')
    #
    # Returns the Backup instance.
    def initialize(config_file)
      @config = Configuration.parse_config(config_file)

      engine = @config.delete("engine")
      @storage = Storage::Base.get_instance(engine, @config[engine])

      @filesystem = Filesystem.new
      @db = DB.new

      @config['jobs'].each do |job|
        backup(job)
      end
    end

    protected

    # Internal: Dump database, compress and upload it.
    #
    # job - the job to execute.
    #
    # @return [nil]
    def backup(job)
      path     = @filesystem.get_tmp_path
      location = @storage.parse_location(job['location'])
      db       = @db.get_opts(job['db'])

      Monsove.logger.info("Starting job for #{db[:host]}:#{db[:port]}/#{db[:db]}")

      @db.dump(db, path)
      @filesystem.compress(path)

      key = "#{location[:prefix]}_#{Time.now.strftime('%m%d%Y_%H%M%S')}.tar.bz2"
      @storage.upload(location[:bucket], key, path)

      @filesystem.cleanup(path)
      @storage.cleanup(location[:bucket], location[:prefix], job['versions'])

      Monsove.logger.info("Finishing job for #{db[:host]}:#{db[:port]}/#{db[:db]}")
    end

  end
end
