#Benchmark for Peach <http://peach.rubyforge.org>
#Count intrawiki links in wikipedia data

require 'peach'
require 'benchmark'
require 'digest/md5'

puts "PEACH BENCHMARK"
puts "Wikipedia Processing"
puts

#Read a small slice of the Wikipedia XML file
fn = "peach_bn_data.txt"
puts "Reading in dataset #{fn}"
puts "Dataset is #{File.size(fn)/1024} kb"
dataset = ""
puts Benchmark.measure("read dataset") { dataset = File.read(fn) }

puts "Splitting dataset into articles"
articles = []
puts Benchmark.measure("split dataset") { 
  articles = dataset.scan(/<text xml:space=\"preserve\">.*?<\/text>/m)
  articles.delete_if {|x| /#redirect/i.match(x) }
}
puts "Found #{articles.size} articles"
puts
puts "BEGIN REAL BENCHMARK"
puts
puts "map:"
links1 = []
puts Benchmark.measure {
  links1 = articles.map do |article|
    article.scan(/\[\[[\w -']+?\]\]/m).each do |link|
      Digest::MD5.hexdigest(link)
    end
  end
}
puts "Found #{links1.flatten.size} links"
puts
puts "pmap:"
links2 = []
puts Benchmark.measure {
  links2 = articles.pmap(6) do |article|
    article.scan(/\[\[[\w -']+?\]\]/m).each do |link| 
      Digest::MD5.hexdigest(link)
    end
  end
}
puts "Found #{links2.flatten.size} links"

p links2 - links1
puts "END"
