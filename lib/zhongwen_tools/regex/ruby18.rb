# encoding: utf-8
module ZhongwenTools
  module Regex
    def py_tones
      {
        'a' => '(ā|á|ǎ|à|a)',
        'e' => '(ē|é|ě|è|e)',
        'i' => '(ī|í|ǐ|ì|i)',
        'o' => '(ō|ó|ǒ|ò|o)',
        'u' => '(ū|ú|ǔ|ù|u)',
        'v' => '(ǖ|ǘ|ǚ|ǜ|ü)'
      }
    end
  end
end
