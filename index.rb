require 'date'

class Util
  def self.p_line(k, v)
    print "- #{k}: "
    p v
  end

  def self.sum(a, b)
    a + b
  end

  def self.def_with_print(name, f, *args)
    puts ">>> #{name} >>>>>"
    f.call(*args)
    puts "<<< #{name} <<<<<"
    print "\n"
  end
end

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
puts '>>> args >>>>>'
# 大文字から始まる値はconst
CONST1 = 'const'
Const2 = 'const'

def args
  $global = 'global set in def'
  Util.p_line(:const1, CONST1)
  Util.p_line(:const2, Const2)

  # :をつけるとシンボル変数
  # 文字列に対応した固定アドレスがglobalに登録されておりそれが使い回される(object_idが同一)
  # (通常の文字列は宣言ごとに変化、というかstringのインスタンスが生成される)
  # 変更不可、どこで参照しても同一のものと判定される
  # ハッシュのキーで利用する場合:を省略可能
  simbol = :simbol
end
$global = 'global'
local = 'local'
args()

Util.p_line(:global, $global)
puts '<<< args <<<<<'
print "\n" # 調整用の改行出力

# nums ==========
def nums
  x = 1
  y = 2

  Util.p_line(:x, x)
  Util.p_line('x + y', x + y)
  Util.p_line('y.object_id', y.object_id)
end
Util.def_with_print('nums', method(:nums))

# arr ==========
def arr
  nums = [1, 2, 3]
  words1 = ['a', 'b', 'c']
  words2 = %w[d e f]

  Util.p_line(:nums, nums)
  Util.p_line(:words1, words1)
  Util.p_line(:words2, words2)
end
Util.def_with_print('arr', method(:arr))

# def(関数) ==========
def def_sample
  # 引数がない場合は[呼び出す場合も]()を記述しなくて良い
  # 最後の出力が返却値として扱われる
  def def1
    3
    2
    1
  end
  Util.p_line(:def1, def1)

  # returnの記述も可能
  def def2
    3
    return 2
    1
  end
  Util.p_line(:def3, def2)

  def def3(arg)
    arg
  end
  Util.p_line(:def3, def3('def3'))

  # method: defをオブジェクト化
  def myvalue(val)
    val
  end
  f = method(:myvalue)
  Util.p_line(:method, f.call('method call'))
end
Util.def_with_print('def', method(:def_sample))

# class ==========
class Sample2
  # コンストラクタ
  def initialize(word)
    # @1つはインスタンス値
    @word = word

    # @2つはクラス値
    @@class_val = word
  end

  # スタティックメソッド
  def self.class_val
    @@class_val
  end

  # インスタンスメソッド
  def getval
    'instance:' + @word + ', classval:' + @@class_val
  end

  def word
    @word
  end
end

class Sample3 < Sample2
  # コンストラクタ
  def initialize(name, word)
    @name = name
    super(word)
  end

  def say
    @name + ' say ' + @word
  end

  def word
    super
  end
end

def class_sample
  sample2_1 = Sample2.new('foo')
  sample2_2 = Sample2.new('bar')
  puts sample2_1.getval
  puts sample2_2.getval
  puts sample2_2.word

  puts '- extends'
  sample3 = Sample3.new('tom', 'cat')
  p sample3.say
  p sample3.getval
  p sample3.word

  puts '- override class_val by child'
  puts sample2_1.getval
end
Util.def_with_print('class', method(:class_sample))

# % 記法 ==========
def perword
  foo = 'foo'

  # %, %Q: ダブルクォートで囲った文字列を生成"'のエスケープが不要
  Util.p_line('%', %(a "'b c #{foo}))
  Util.p_line('%Q', %Q(d "'e 9 #{foo}))

  # %q: シングルクォートで囲った文字列を生成"'のエスケープが不要
  Util.p_line('%q', %q(d "e" 9 #{foo}))

  # %w, %W: 配列を生成 (大文字の方は式を展開)
  Util.p_line('%w', %w[a b c #{foo}])
  Util.p_line('%W', %W[a b c #{foo}])

  # %i, %I: シンボル値の配列を生成 (大文字の方は式を展開)
  Util.p_line('%i', %i(i1 i2 i3 #{foo}))
  Util.p_line('%I', %I(i1 i2 i3 #{foo}))

  # %s: シンボル値を生成
  Util.p_line('%s', %s(s))

  # %x: osコマンドを実行 (バッククオートで囲った場合と同様)
  command = %q(date '+%F')
  Util.p_line('%x', %x(#{command}))
end
Util.def_with_print('perword', method(:perword))

# lambda ==========
# procよりもlambdaのほうが厳格に動作する
def lambda_proc
  lmd1 = lambda { |x| x + x }
  Util.p_line('lambda', lmd1.call(1))

  lmd2 = ->x{ x + x }
  Util.p_line('->', lmd2.call(2))

  prc1 = proc { |x| x + x }
  Util.p_line('proc', prc1.call(3))

  prc2 = Proc.new { |x| x + x }
  Util.p_line('Proc.new', prc2.call(4))
end
Util.def_with_print('lambda_proc', method(:lambda_proc))

# hash ==========
def hash_sample
  # シンボルで宣言
  hash = { a: 1, "b": 2, c: 3, d: 4, e: 5}
  Util.p_line('a', hash[:a])
  Util.p_line('"a"', hash['a']) # nil

  # 文字列で宣言
  hash2 = { "c" => 3, "d" => 4 }
  Util.p_line('c', hash2[:c]) # nil
  Util.p_line('"c"', hash2['c'])

  # each 系 ---------
  print "-- each\n"
  hash.each{|k, v| print "#{k} => #{v}\n" }
  hash.each do |k, v|
    print "#{k} => #{v}\n"
  end
  hash.each_key{|k| print "key: #{k}\n" }
  hash.each_value{|v| print "val: #{v}\n" }

  # break, next, redo
  print "-- break, next, redo\n"
  count = 0
  hash.each{|k, v|
    count += 1

    print "#{k} => #{v}.\n"
    case count
    when 2
      next # いわゆる continue
    when 3
      redo # continueのポインタ移動しない版
    when 4
      break
    end

    print "#{k} => #{v}. throw\n"
  }
end
Util.def_with_print('hash', method(:hash_sample))


