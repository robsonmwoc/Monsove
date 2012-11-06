require 'spec_helper'

describe Monsove::Configuration do
  let(:config) { Monsove.config }

  context "default settings" do
    it "should the benchmark_tool default value be" do
      benchmark_tool = config.benchmark_tool.new
      benchmark_tool.is_a?(::Monsove::Tools::ApacheBenchmark).should be_true
    end

    it "should the log_path default value be" do
      config.log_path.should == "/tmp"
    end
  end

  context "changing configurations" do
    before {
      Monsove.configure do |config|
        config.benchmark_tool = ::Monsove::SampleBenchmarkTool
        config.log_path = "/new/path"
      end
    }
    
    let(:config) { Monsove.config }

    it "should set up the benchmark_tool" do
      benchmark_tool = config.benchmark_tool.new
      benchmark_tool.is_a?(::Monsove::SampleBenchmarkTool).should be_true
    end

    it "should set up the log_path" do
      config.log_path.should == "/new/path"
    end

  end
end
