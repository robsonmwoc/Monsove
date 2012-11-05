module Monsove
  class Cli < Thor
    include Thor::Actions

    # def self.source_root
    #   File.dirname(__FILE__)
    # end

    # desc "init", "Generates a configuration file into the current working directory"
    # def init
    #   Monsove.logger.info("NOT IMPLEMENTED")
    #   # @host = ask_with_default("mongo host: ", "localhost")
    #   # @port = ask_with_default("mongo port: ", "27017")
    #   # @mongodump = ask_with_default("mongodump path: ", "/usr/bin/mongodump")
    #   # @access_key_id = ask("s3 access key id:")
    #   # @secret_access_key = ask("s3 secret access key:")
    #   # @bucket = ask("s3 bucket:")

    #   # template('templates/config.tt', "mongobacker.yml")
    # end

    desc "backup", "backup the configured mongodb"
    method_option :config, :type => :string, :aliases => "-c", :required => true,
                  :desc => "Path to config file"
    def backup
      Monsove::Backup.new(options[:config])
    end

    desc "list", "list the backups currently on storage"
    method_option :config, :type => :string, :aliases => "-c", :required => true,
                  :desc => "Path to config file"
    def list
      config  = Configuration.parse_jobfile(options[:config])
      engine  = config.delete('engine')
      storage = Storage::Base.get_instance(engine, config[engine])

      config['jobs'].each do |job|
        storage.list(job['location'])
      end
    end

    desc "restore", "restore the database from a mongodump backup file"
    method_option :config, :type => :string, :aliases => "-c", :required => true,
                  :desc => "Path to config file"
    method_option :backup_file, :type => :string, :aliases => "-b", :required => true,
                  :desc => "Name of the file to be restored"
    def restore
      config  = Configuration.parse_jobfile(options[:config])
      engine  = config.delete('engine')

      storage = Storage::Base.get_instance(engine, config[engine])

      config['jobs'].each do |job|
        storage.download(options[:backup_file], job)

        db = DB.new
        storage.restore(db, job, options[:backup_file])
      end
    end

    desc "version", "mongobacker version"
    def version()
        puts "mongobacker version #{MongoBacker::Version}"
    end

    # def help
    #   puts "helpppppp"
    # end
  end

end