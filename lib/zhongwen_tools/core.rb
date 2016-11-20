# encoding: utf-8
require "zhongwen_tools/ruby_19" if RUBY_VERSION < "2.0.0"
require "zhongwen_tools/regex"
require "zhongwen_tools/fullwidth"
require "zhongwen_tools/unicode"
require "zhongwen_tools/uri"
require "zhongwen_tools/zhongwen"
require "zhongwen_tools/number"
require "zhongwen_tools/romanization"
require "zhongwen_tools/string_extension"
require "zhongwen_tools/version"

module ZhongwenTools
  # Allow for the use Refinements.
  if RUBY_VERSION >= "2.0.0"
    refine String do
      include ::ZhongwenTools::StringExtension

      def respond_to?(method, include_private = false)
        super || ::ZhongwenTools::StringExtension.instance_methods.include?(method)
      end
    end
  end
end
