# -*- coding: UTF-8 -*-

module IpMethods
  module IPv6
    TOTAL_BIT_SIZE = 128
    GROUP_BIT_SIZE = 16
    IPV6_PATTERN = /^(?:[\da-f]{1,4}:){7}[\da-f]{1,4}$/i
    
    def self.uncompress(ip)
      missing_groups = (TOTAL_BIT_SIZE/GROUP_BIT_SIZE) - ip.gsub(/[^:]/, "").size
      ip.sub(/^:/, "0:").sub(/:$/, ":0").sub(/::/, ":0" * missing_groups + ":")
    end
    
    def self.ipv6?(ip)
      !! uncompress(ip) =~ IPV6_PATTERN
    end
  end
end