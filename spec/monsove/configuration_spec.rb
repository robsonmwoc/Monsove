require 'spec_helper'

describe Monsove::Configuration do
  let(:config) { Monsove.config }

  context "SCP as storage" do
    before {
      Monsove.configure do |config|
        config.storage  = Monsove::Storage::SCP
        config.server   = "localhost"
        config.username = "ubuntu"
        config.ssh_key  = "/path/to/ssh_key"
      end
    }

    let(:config) { Monsove.config }

    it "should storage be equal to scp" do
      storage = config.storage.new
      storage.is_a?(::Monsove::Storage::SCP).should be_true
    end

    it "should server be equal to localhost" do
      config.server.should == "localhost"
    end

    it "should username be equal to ubuntu" do
      config.username.should == "ubuntu"
    end

    it "should ssh_key be equal to /path/to/ssh_key" do
      config.ssh_key.should == "/path/to/ssh_key"
    end
  end

  context "S3 as storage" do
    before {
      Monsove.configure do |config|
        config.storage    = Monsove::Storage::S3
        config.access_id  = "test_id"
        config.secret_key = "test_key"
      end
    }

    let(:config) { Monsove.config }

    it "should storage be s3" do
      storage = config.storage.new
      storage.is_a?(::Monsove::Storage::S3).should be_true
    end

    it "should access_id be equal to test_id" do
      config.access_id.should == "test_id"
    end

    it "should secret_key be equal to test_key" do
      config.secret_key.should == "test_key"
    end
  end

  context "General configuration" do
    before {
      Monsove.configure do |config|
        config.location = "/path/to/bucket"
        config.versions = 5
        config.database = "mongodb://localhost:27017/mydatabase"
      end
    }

    let(:config) { Monsove.config }

    it "should location be equal to /path/to/bucket" do
      config.location.should == "/path/to/bucket"
    end

    it "should versions be equal to 5" do
      config.versions.should == 5
    end

    it "should database be equal to mongodb://localhost:27017/mydatabase" do
      config.database.should == "mongodb://localhost:27017/mydatabase"
    end
  end
end
