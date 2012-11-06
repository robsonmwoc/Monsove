require 'spec_helper'

describe Monsove do
  it "should logger be a Logger instance" do
    Monsove.logger.class.should == Logger
  end

  it "should get an error without configured storage" do
    lambda { Monsove.storage }.should raise_exception(NoMethodError)
  end

  it "should have a storage associated" do
    Monsove.configure do |config|
      config.storage = Monsove::Storage::SCP
    end
    Monsove.storage.class.should == Monsove::Storage::SCP
    Monsove.storage.is_a?(Monsove::Storage::SCP).should be_true
  end
end