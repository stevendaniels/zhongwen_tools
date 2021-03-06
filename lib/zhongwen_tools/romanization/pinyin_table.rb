# encoding: utf-8

# NOTE: This table works for pyn -> pinyin conversion, but it introduces
#       mistakes when converting pinyin to pyn. In practice, pinyin can't
#       be converted to pyn with complete accuracy unless it is properly
#       formatted.
module ZhongwenTools
  module Romanization
    PYN_SYLLABIC_NASALS = %w(ng m n)

    PYN_PY = {
      'A1' => 'Ā',
      'A2' => 'Á',
      'A3' => 'Ǎ',
      'A4' => 'À',
      'A5' => 'A',
      'Ai1' => 'Āi',
      'Ai2' => 'Ái',
      'Ai3' => 'Ǎi',
      'Ai4' => 'Ài',
      'Ai5' => 'Ai',
      'Ao1' => 'Ā',
      'Ao2' => 'Áo',
      'Ao3' => 'Ǎo',
      'Ao4' => 'Ào',
      'Ao5' => 'Ao',
      'a1' => 'ā',
      'a2' => 'á',
      'a3' => 'ǎ',
      'a4' => 'à',
      'a5' => 'a',
      'e1' => 'ē',
      'e2' => 'é',
      'e3' => 'ě',
      'e4' => 'è',
      'e5' => 'e',
      'i1' => 'ī',
      'i2' => 'í',
      'i3' => 'ǐ',
      'i4' => 'ì',
      'i5' => 'i',
      'O1' => 'Ō',
      'O2' => 'Ó',
      'O3' => 'Ǒ',
      'O4' => 'Ò',
      'O5' => 'O',
      'o1' => 'ō',
      'o2' => 'ó',
      'o3' => 'ǒ',
      'o4' => 'ò',
      'o5' => 'o',
      'u1' => 'ū',
      'u2' => 'ú',
      'u3' => 'ǔ',
      'u4' => 'ù',
      'u5' => 'u',
      'ai1' => 'āi',
      'ai2' => 'ái',
      'ai3' => 'ǎi',
      'ai4' => 'ài',
      'ai5' => 'ai',
      'ao1' => 'āo',
      'ao2' => 'áo',
      'ao3' => 'ǎo',
      'ao4' => 'ào',
      'ao5' => 'ao',
      'E1' => 'Ē',
      'E2' => 'É',
      'E3' => 'Ě',
      'E4' => 'È',
      'E5' => 'E',
      'Ei1' => 'Ēi',
      'Ei2' => 'Éi',
      'Ei3' => 'Ěi',
      'Ei4' => 'Èi',
      'Ei5' => 'Ei',
      'ei1' => 'ēi',
      'ei2' => 'éi',
      'ei3' => 'ěi',
      'ei4' => 'èi',
      'ei5' => 'ei',
      'ia1' => 'iā',
      'ia2' => 'iá',
      'ia3' => 'iǎ',
      'ia4' => 'ià',
      'ia5' => 'ia',
      'iao1' => 'iāo',
      'iao2' => 'iáo',
      'iao3' => 'iǎo',
      'iao4' => 'iào',
      'iao5' => 'iao',
      'ie1' => 'iē',
      'ie2' => 'ié',
      'ie3' => 'iě',
      'ie4' => 'iè',
      'ie5' => 'ie',
      'io1' => 'iō',
      'io2' => 'ió',
      'io3' => 'iǒ',
      'io4' => 'iò',
      'io5' => 'io',
      'iu1' => 'iū',
      'iu2' => 'iú',
      'iu3' => 'iǔ',
      'iu4' => 'iù',
      'iu5' => 'iu',
      'Ou1' => 'Ōu',
      'Ou2' => 'Óu',
      'Ou3' => 'Ǒu',
      'Ou4' => 'Òu',
      'Ou5' => 'Ou',
      'ou1' => 'ōu',
      'ou2' => 'óu',
      'ou3' => 'ǒu',
      'ou4' => 'òu',
      'ou5' => 'ou',
      'ua1' => 'uā',
      'ua2' => 'uá',
      'ua3' => 'uǎ',
      'ua4' => 'uà',
      'ua5' => 'ua',
      'uai1' => 'uāi',
      'uai2' => 'uái',
      'uai3' => 'uǎi',
      'uai4' => 'uài',
      'uai5' => 'uai',
      'ue1' => 'uē',
      'ue2' => 'ué',
      'ue3' => 'uě',
      'ue4' => 'uè',
      'ue5' => 'ue',
      'ui1' => 'uī',
      'ui2' => 'uí',
      'ui3' => 'uǐ',
      'ui4' => 'uì',
      'ui5' => 'ui',
      'uo1' => 'uō',
      'uo2' => 'uó',
      'uo3' => 'uǒ',
      'uo4' => 'uò',
      'uo5' => 'uo',
      'v1' => 'ǖ',
      'v2' => 'ǘ',
      'v3' => 'ǚ',
      'v4' => 'ǜ',
      'v5' => 'ü',
      've1' => 'üē',
      've2' => 'üé',
      've3' => 'üě',
      've4' => 'üè',
      've5' => 'üe',
      'm1' => 'm̄',
      'm2' => 'ḿ', # using combining diacritical marks
      'm3' => 'm̌', # using combining diacritical marks
      'm4' => 'm̀', # using combining diacritical marks
      'm5' => 'm',
      'n1' => 'n̄',
      'n2' => 'ń',
      'n3' => 'ň',
      'n4' => 'ǹ',
      'n5' => 'n',
      'Ng1' => 'N̄g', # using combining diacritical marks
      'Ng2' => 'Ńg',
      'Ng3' => 'Ňg', # using combining diacritical marks
      'Ng4' => 'Ǹg',
      'Ng5' => 'Ng',
      'ng1' => 'n̄g', # using combining diacritical marks
      'ng2' => 'ńg',
      'ng3' => 'ňg', # using combining diacritical marks
      'ng4' => 'ǹg',
      'ng5' => 'ng',
      'r5' => 'r',
      'ang1' => 'āng',
      'ang2' => 'áng',
      'ang3' => 'ǎng',
      'ang4' => 'àng',
      'ang5' => 'ang',
      'eng1' => 'ēng',
      'eng2' => 'éng',
      'eng3' => 'ěng',
      'eng4' => 'èng',
      'eng5' => 'eng',
      'ing1' => 'īng',
      'ing2' => 'íng',
      'ing3' => 'ǐng',
      'ing4' => 'ìng',
      'ing5' => 'ing',
      'ong1' => 'ōng',
      'ong2' => 'óng',
      'ong3' => 'ǒng',
      'ong4' => 'òng',
      'ong5' => 'ong',
    }
  end
end
