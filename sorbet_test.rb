# typed: true
require 'bundler/setup'
require 'sorbet-runtime'

class Klass
  extend T::Sig

  def initialize(hash)
    @hash_with_sig = hash
    @hash_without_sig = hash
  end

  sig { returns(T::Hash[String, String]) }
  attr_reader :hash_with_sig

  attr_reader :hash_without_sig

  sig { returns(T::Hash[String, String]).checked(:never) }
  attr_reader :hash_with_sig_never_checked
end

require 'benchmark/ips'

puts ""
hash_size = 5000
puts "preparing hash with #{hash_size} keys (string) whose values are also strings..."
obj2 = nil
big_hash = {}
(0..hash_size).each do |i|
  big_hash[i.to_s] = i.to_s
end
obj2 = Klass.new(big_hash)
puts "starting benchmark"
Benchmark.ips { |x| x.report("hash_with_sig") { obj2.hash_with_sig } }
Benchmark.ips { |x| x.report("hash_without_sig") { obj2.hash_without_sig } }
Benchmark.ips { |x| x.report("hash_with_sig_never_checked") { obj2.hash_with_sig_never_checked } }

hash_size = 50
puts "preparing hash with #{hash_size} keys (string) whose values are also strings..."
obj2 = nil
big_hash = {}
(0..hash_size).each do |i|
  big_hash[i.to_s] = i.to_s
end
obj2 = Klass.new(big_hash)
puts "starting benchmark"
Benchmark.ips { |x| x.report("hash_with_sig") { obj2.hash_with_sig } }
Benchmark.ips { |x| x.report("hash_without_sig") { obj2.hash_without_sig } }
Benchmark.ips { |x| x.report("hash_with_sig_never_checked") { obj2.hash_with_sig_never_checked } }

hash_size = 5
puts "preparing hash with #{hash_size} keys (string) whose values are also strings..."
obj2 = nil
big_hash = {}
(0..hash_size).each do |i|
  big_hash[i.to_s] = i.to_s
end
obj2 = Klass.new(big_hash)
puts "starting benchmark"
Benchmark.ips { |x| x.report("hash_with_sig") { obj2.hash_with_sig } }
Benchmark.ips { |x| x.report("hash_without_sig") { obj2.hash_without_sig } }
Benchmark.ips { |x| x.report("hash_with_sig_never_checked") { obj2.hash_with_sig_never_checked } }

