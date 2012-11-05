module Monsove
  class Filesystem

    # Initialize a ne Filesystem object.
    #
    # @return [Filesytem]
    def initialize

    end

    # Compress the dump to an tar.bz2 archive.
    #
    # @param [String] path the path, where the dump is located.
    #
    # @return [nil]
    def compress(path)
      Monsove.logger.info("Compressing database #{path}")

      system("cd #{path} && tar -cjpf #{path}.tar.bz2 .")
      raise "Error while compressing #{path}" if $?.to_i != 0
    end

    def decompress(path)
      Monsove.logger.info("Decompressing databse dump #{path}")

      system("cd #{File.dirname(path)} && tar -xjpf #{path}")
      raise "Error while decompressing #{path}" if $?.to_i != 0
    end

    # Generate tmp path for dump.
    #
    # @return [String]
    def get_tmp_path
      "#{Dir.tmpdir}/#{Time.now.to_i * rand}"
    end

    # Remove dump and archive from tmp path.
    #
    # @param [String] path the path, where the dump/archive is located.
    #
    # @return [nil]
    def cleanup(path)
      Monsove.logger.info("Cleaning up local path #{path}")

      FileUtils.rm_rf(path)
      File.delete("#{path}.tar.bz2")
    end

  end
end