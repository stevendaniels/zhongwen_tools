# encoding: utf-8

module ZhongwenTools
  module Number
    # TODO: Add huge numbers.
    # 垓	秭	穰	溝	澗	正	載 --> beyond 100,000,000!
    # NOTE: financial numbers i == 0 ? NT.select{ |x| x[:i] == i }.last[:zhs] : NT.find{ |x| x[:i] = i }
    NUMBERS_TABLE = [
      { zhs: '零', zht: '零', i: 0, pyn: 'ling2' },
      { zhs: '〇', zht: '〇', i: 0, pyn: 'ling2' },
      { zhs: '一', zht: '一', i: 1, pyn: 'yi1' },
      { zhs: '壹', zht: '壹', i: 1, pyn: 'yi1' },
      { zhs: '幺', zht: '幺', i: 1, pyn: 'yao1' },
      { zhs: '二', zht: '二', i: 2, pyn: 'er4' },
      { zhs: '两', zht: '兩', i: 2, pyn: 'liang3' },
      { zhs: '贰', zht: '貳', i: 2, pyn: 'er4' },
      { zhs: '三', zht: '三', i: 3, pyn: 'san1' },
      { zhs: '弎', zht: '弎', i: 3, pyn: 'san1' },
      { zhs: '叁', zht: '參', i: 3, pyn: 'san1' },
      { zhs: '四', zht: '四', i: 4, pyn: 'si4' },
      { zhs: '䦉', zht: '䦉', i: 4, pyn: 'si4' },
      { zhs: '肆', zht: '肆', i: 4, pyn: 'si4' },
      { zhs: '五', zht: '五', i: 5, pyn: 'wu3' },
      { zhs: '伍', zht: '伍', i: 5, pyn: 'wu3' },
      { zhs: '六', zht: '六', i: 6, pyn: 'liu4' },
      { zhs: '陆', zht: '陸', i: 6, pyn: 'liu4' },
      { zhs: '七', zht: '七', i: 7, pyn: 'qi1' },
      { zhs: '柒', zht: '柒', i: 7, pyn: 'qi1' },
      { zhs: '八', zht: '八', i: 8, pyn: 'ba1' },
      { zhs: '捌', zht: '捌', i: 8, pyn: 'ba1' },
      { zhs: '九', zht: '九', i: 9, pyn: 'jiu3' },
      { zhs: '玖', zht: '玖', i: 9, pyn: 'jiu3' },
      { zhs: '十', zht: '十', i: 10, pyn: 'shi2' },
      { zhs: '拾', zht: '拾', i: 10, pyn: 'shi2' },
      { zhs: '廿', zht: '廿', i: 20, pyn: ' nian4' },
      { zhs: '百', zht: '百', i: 100, pyn: 'bai2' },
      { zhs: '佰', zht: '佰', i: 100, pyn: 'bai2' },
      { zhs: '千', zht: '千', i: 1_000, pyn: 'qian1' },
      { zhs: '仟', zht: '仟', i: 1_000, pyn: 'qian1' },
      { zhs: '万', zht: '萬', i: 10_000, pyn: 'wan4' },
      { zhs: '亿', zht: '億', i: 100_000_000, pyn: 'yi4' },
    ]
  end
end
