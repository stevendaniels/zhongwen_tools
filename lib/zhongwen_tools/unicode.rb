# encoding: utf-8

module ZhongwenTools
  module Unicode
    def self.to_codepoint(str)
      str.chars.map{ |c| "\\u%04x" % c.unpack("U")[0] }.join
    end

    def self.from_codepoint(str)
      results = (str.split(/\\?u/) - ['']).map do |s|
        [s.hex].pack("U")
      end

      results.join
    end

    def self.ascii?(str)
      str.chars.to_a.size == str.bytes.to_a.size
    end

    def self.multibyte?(str)
      !ascii?(str)
    end
  end
end
