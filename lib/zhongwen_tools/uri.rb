# encoding: utf-8
require 'uri'

module ZhongwenTools
  module URI
    def self.encode(str)
      ::URI.encode str
    end

    def self.escape(str)
      ::URI.escape(str, Regexp.new("[^#{ ::URI::PATTERN::UNRESERVED }]"))
    end
  end
end
