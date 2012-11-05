require 'uri'
require 'thor'
require 'tmpdir'
require 'logger'
require 'fileutils'
require 'yaml'
require "monsove/version"

LOGGER = Logger.new(STDOUT)

module Monsove
  def self.logger
    LOGGER
  end

  # An abstract interface module to validate the implementation of different
  # file storages (s3, cloud files, object storage, etc).
  module AbstractInterface

    class InterfaceNotImplementedError < NoMethodError; end

    def self.included(klass)
      klass.send(:include, AbstractInterface::Methods)
      klass.send(:extend, AbstractInterface::Methods)
    end

    module Methods

      def not_implemented(klass)
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
        error_message  = "#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!"
        raise AbstractInterface::InterfaceNotImplementedError.new(error_message)
      end

    end
  end
end

require 'monsove/configuration'
require 'monsove/backup'
require 'monsove/filesystem'
require 'monsove/storage'
require 'monsove/db'
require 'monsove/storage/aws'
require 'monsove/storage/scp'
require 'monsove/cli'
