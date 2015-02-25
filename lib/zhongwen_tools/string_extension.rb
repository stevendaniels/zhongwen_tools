# encoding: utf-8

module ZhongwenTools
  module StringExtension
    def capitalize
      ZhongwenTools::Caps.capitalize(self)
    end

    def zh_downcase
      ZhongwenTools::Caps.downcase(self)
    end

    def zh_upcase
      ZhongwenTools::Caps.upcase(self)
    end

    def has_zh?
      ZhongwenTools::Zhongwen.has_zh?(self)
    end

    def has_zh_punctuation?
      ZhongwenTools::Zhongwen.has_zh_punctuation?(self)
    end

    def zh?
      ZhongwenTools::Zhongwen.zh?(self)
    end

    def strip_zh_punctuation
      ZhongwenTools::Zhongwen.strip_zh_punctuation(self)
    end

    def uri_encode
      ZhongwenTools::URI.encode(self)
    end

    def uri_escape
      ZhongwenTools::URI.escape(self)
    end

    def ascii?
      ZhongwenTools::Unicode.ascii?(self)
    end

    def multibyte?
      ZhongwenTools::Unicode.multibyte?(self)
    end

    def halfwidth?
      ZhongwenTools::Fullwidth.halfwidth?(self)
    end

    def fullwidth?
      ZhongwenTools::Fullwidth.fullwidth?(self)
    end

    def to_halfwidth
      ZhongwenTools::Fullwidth.to_halfwidth(self)
    end

    def to_codepoint
      ZhongwenTools::Unicode.to_codepoint(self)
    end

    def from_codepoint
      ZhongwenTools::Unicode.from_codepoint(self)
    end

    def to_pinyin(from = nil)
      ZhongwenTools::Romanization::Pinyin::to_py(self, from)
    end

    alias_method :to_py, :to_pinyin

    def to_pyn(from = nil)
      ZhongwenTools::Romanization::Pinyin::to_pyn(self, from)
    end

    def to_bpmf(from = nil)
      ZhongwenTools::Romanization::ZhuyinFuhao::to_bpmf(self, from)
    end

    alias_method :to_zyfh, :to_bpmf
    alias_method :to_zhyfh, :to_bpmf
    alias_method :to_bopomofo, :to_bpmf

    def to_wg(from = nil)
      ZhongwenTools::Romanization::WadeGiles::to_wg(self, from)
    end

    alias_method :to_wade_giles, :to_wg

    def to_yale(from = nil)
      ZhongwenTools::Romanization::Yale::to_yale(self, from)
    end

    def to_typy(from = nil)
      ZhongwenTools::Romanization::TongyongPinyin::to_typy(self, from)
    end

    alias_method :to_tongyong, :to_typy
    alias_method :to_tongyong_pinyin, :to_typy

    def to_mps2(from = nil)
      ZhongwenTools::Romanization::MPS2::to_mps2(self, from)
    end

    def py?
      ZhongwenTools::Romanization::Pinyin.py?(self)
    end

    def pyn?
      ZhongwenTools::Romanization::Pinyin.pyn?(self)
    end

    def bpmf?
      ZhongwenTools::Romanization::ZhuyinFuhao.bpmf?(self)
    end

    def wg?
      ZhongwenTools::Romanization::WadeGiles.wg?(self)
    end

    def yale?
      ZhongwenTools::Romanization::Yale.yale?(self)
    end

    def typy?
      ZhongwenTools::Romanization::TongyongPinyin.typy?(self)
    end

    def mps2?
      ZhongwenTools::Romanization::MPS2.mps2?(self)
    end

    def romanization?
      ZhongwenTools::Romanization.romanization?(self)
    end

    def split_romanization
      ZhongwenTools::Romanization.split(self)
    end

    def zhs?
      ZhongwenTools::Script.zhs?(self)
    end

    def zht?
      ZhongwenTools::Script.zht?(self)
    end

    def to_zhcn
      ZhongwenTools::Script.to_zhs(self, :zhcn)
    end

    def to_zhhk
      ZhongwenTools::Script.to_zht(self, :zhhk)
    end

    def to_zhs
      ZhongwenTools::Script.to_zhs(self, :zhs)
    end

    def to_zht
      ZhongwenTools::Script.to_zht(self, :zht)
    end

    def to_zhtw
      ZhongwenTools::Script.to_zht(self, :zhtw)
    end
  end
end
