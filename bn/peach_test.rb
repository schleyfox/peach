require 'peach'
require 'benchmark'

def fac(n)
  if n == 0
    return 1
  else
    n*fac(n-1)
  end
end


puts "PEACH TEST"
puts "each:"
def each_test
  (0...1000).to_a.sort_by{rand}.each do |x|
    fac(x)
  end
end
puts Benchmark.measure { each_test }

puts "peach:"
def peach_test
  (0...1000).to_a.sort_by{rand}.peach(4) do |x|
    fac(x)
  end
end
puts Benchmark.measure { peach_test }

puts "map:"
def map_test
  (0...1000).to_a.sort_by{rand}.map do |x|
    fac(x)
  end
end
puts Benchmark.measure { map_test }


puts "pmap:"
def pmap_test
  (0...1000).to_a.sort_by{rand}.pmap(4) do |x|
    fac(x)
  end
end
puts Benchmark.measure { pmap_test }

