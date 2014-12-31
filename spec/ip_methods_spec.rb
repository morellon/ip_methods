# -*- coding: UTF-8 -*-
require "spec_helper"

describe IpMethods do

  subject { IpMethods::SimpleIP.new "10.1.2.34", 26 }

  it "should give the binary ip representation" do
    subject.to_bin.should == 0b00001010_00000001_00000010_00100010
  end

  it "should convert from binary ip representation" do
    IpMethods.from_bin(subject.to_bin).should == subject.address
  end

  it "should give the ip's network address" do
    subject.network.should == "10.1.2.0"
  end

  it "should give the ip's broadcast address" do
    subject.broadcast.should == "10.1.2.63"
  end

  it "should give the ip's default gateway address" do
    subject.default_gateway.should == "10.1.2.1"
  end

  it "should give the ip's net mask address" do
    subject.net_mask.should == "255.255.255.192"
  end

  it "should generate all host ips on this ip range" do
    ips = []
    ip = subject.network
    62.times {|i| ips << "10.1.2.#{i+1}"}
    subject.generate_ips.should == ips
  end

  it "should belong to a wider range" do
    subject.belongs_to?(IpMethods::SimpleIP.new "10.1.2.34", subject.mask - 1).should be_true
    subject.belongs_to?(IpMethods::SimpleIP.new "0.0.0.0/0").should be_true
  end

  it "should belong to itself" do
    subject.belongs_to?(subject).should be_true
    subject.belongs_to?(IpMethods::SimpleIP.new "10.1.2.32/26").should be_true
  end

  it "should not belong to a narrower range" do
    subject.belongs_to?(IpMethods::SimpleIP.new "10.1.2.34", subject.mask + 1).should be_false
  end

  it "should not belong to a different range" do
    subject.belongs_to?(IpMethods::SimpleIP.new "10.2.2.0/26").should be_false
  end
end
