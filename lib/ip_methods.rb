# -*- coding: UTF-8 -*-
require "ip_methods/version"

module IpMethods
  IPV4_PATTERN = /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/
  IPV4_BIT_WIDTH = 32
  IPV4_BIT_OCTET = 8

  def self.from_bin(ip_bin)
    "#{ip_bin >> 24}.#{(ip_bin >> 16) & 255}.#{(ip_bin >> 8) & 255}.#{ip_bin & 255}"
  end

  def self.ip?(ip)
    ip =~ IPV4_PATTERN
  end

  def self.mask?(mask)
    mask.to_s =~ /^\d+$/ && (0..32).include?(mask.to_i)
  end

  def self.ip_and_mask?(address)
    parts = address.to_s.split('/')
    parts.size == 2 && ip?(parts[0]) && mask?(parts[1])
  end

  def self.to_bin(ip)
    ip_bin = 0
    shift = IPV4_BIT_WIDTH - IPV4_BIT_OCTET
    ip.split('.').each do |part|
      ip_bin += (part.to_i << shift)
      shift  -= IPV4_BIT_OCTET
    end
    ip_bin
  end

  def network
    IpMethods.from_bin(network_bin)
  end

  def net_mask
    IpMethods.from_bin(mask_bin)
  end

  def default_gateway
    IpMethods.from_bin(network_bin+1)
  end

  def broadcast
    IpMethods.from_bin(broadcast_bin)
  end

  def generate_ips
    (network_bin+1..broadcast_bin-1).map {|ip_bin| IpMethods.from_bin(ip_bin)}
  end

  def to_bin
    IpMethods.to_bin(address)
  end

  def mask_bin
    umask = 0
    range = 32 - mask
    (0..mask-1).each {|i| umask += 1 << i}
    umask << range
  end

  def umask_bin
    umask = 0
    range = 32 - mask
    (0..range-1).each {|i| umask += 1 << i}
    umask
  end

  def network_bin
    self.to_bin & mask_bin
  end

  def broadcast_bin
    mask_bin & network_bin | umask_bin;
  end

  def belongs_to?(range)
    range = SimpleIP.new(range) unless range.is_a? IpMethods
    range.mask <= self.mask && SimpleIP.new(self.address, range.mask).network == range.network
  end

  class SimpleIP
    include IpMethods
    attr_accessor :address, :mask

    def initialize(address, mask = 32)
      (@address, @mask) = address.split('/')
      @mask ||= mask
      @mask = @mask.to_i
    end
  end
end
