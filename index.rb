# stdout ==========
# 標準出力は3種類
## p: 引数を展開して出力、文字列化 returnあり
## puts: 引数を展開して出力、改行あり、returnなし
## print: 引数を展開して出力、改行なし、returnなし
# p が細かく, putsは見やすい, print はカスタマイズがしやすい
def stdout(val)
  puts '>>> stdout >>>>>'

  puts '-- p'
  p val
  puts '-- puts'
  puts val
  puts '-- print'
  print val

  print "\n" # 調整用の改行出力
  puts '<<< stdout <<<<<'
  print "\n" # 調整用の改行出力
end
stdout('hello world')
stdout(%w[hello world])

class Sample1
  def initialize(word)
    @word = word
  end
end
stdout(Sample1.new('hello world 1'))
stdout(Sample1.new('hello world 2'))

# args ==========
# 大文字から始まる値はconst
CONST1 = 'const'
Const2 = 'const'

def args
  $global = 'global set in def'
  p '- const1', $CONST1
  p '- const2', $Const2

  # :をつけるとシンボル変数
  # 文字列に対応した固定アドレスがglobalに登録されておりそれが使い回される(object_idが同一)
  # (通常の文字列は宣言ごとに変化、というかstringのインスタンスが生成される)
  # 変更不可、どこで参照しても同一のものと判定される
  # ハッシュのキーで利用する場合:を省略可能
  simbol = :simbol
end
$global = 'global'
local = 'local'
puts '>>> args >>>>>'
args()

p '- global', $global
puts '<<< args <<<<<'
print "\n" # 調整用の改行出力

# nums ==========
def nums
  puts '>>> nums >>>>>'
  x = 1
  y = 2

  puts '- x', x
  puts '- x + y', x + y
  puts '- y.object_id', y.object_id
  puts '<<< nums <<<<<'
  print "\n" # 調整用の改行出力
end
nums

# arr ==========
def arr
  puts '>>> arr >>>>>'

  nums = [1, 2, 3]
  words1 = ['a', 'b', 'c']
  words2 = %w[d e f]

  puts '- nums', nums
  puts '- words1', words1
  puts '- words2', words2
  puts '<<< nums <<<<<'
  print "\n" # 調整用の改行出力
end
arr

# def(関数) ==========
def def_sample
  puts '>>> def >>>>>'
  # 引数がない場合は[呼び出す場合も]()を記述しなくて良い
  # 最後の出力が返却値として扱われる
  def def1
    3
    2
    1
  end
  p def1

  # returnの記述も可能
  def def2
    3
    return 2
    1
  end
  p def2

  def def3(arg)
    arg
  end
  p def3('def3')
  puts '<<< def <<<<<'
  print "\n" # 調整用の改行出力
end
def_sample

# class ==========
class Sample2
  # コンストラクタ
  def initialize(word)
    # @1つはインスタンス値
    @val = word

    # @2つはクラス値
    @@class_val = word
  end

  # スタティックメソッド
  def self.class_val
    @@class_val
  end

  # インスタンスメソッド
  def getval
    'instance:' + @val + ', classval:' + @@class_val
  end
end

def class_sample
  puts '>>> class >>>>>'
  sample2_1 = Sample2.new('foo')
  sample2_2 = Sample2.new('bar')
  p sample2_1.getval
  p sample2_2.getval
  puts '<<< class <<<<<'
  print "\n" # 調整用の改行出力
end
class_sample

# % 記法 ==========
