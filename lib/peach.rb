module Peach
  def peach(pool = nil, &b)
    pool ||= $peach_default_threads || count
    raise "Thread pool size less than one?" unless pool >= 1
    div = (count/pool).to_i      # should already be integer
    div = 1 unless div >= 1     # each thread better do something!
    
    threads = []
    each_slice(div) do |slice|
      threads << Thread.new(slice){|thread_slice| thread_slice.each{|elt| yield elt}}
    end
    threads.each { |t| t.join }
    self
  end

  def pmap(pool = nil, &b)
    pool ||= $peach_default_threads || count
    raise "Thread pool size less than one?" unless pool >= 1
    div = (count/pool).to_i      # should already be integer
    div = 1 unless div >= 1     # each thread better do something!

    result = Array.new(count)

    threads = []
    each_slice(div).with_index do |slice, idx|
      threads << Thread.new(slice){|thread_slice| thread_slice.each_with_index{|elt, offset| result[idx+offset] = yield elt}}
    end
    threads.each { |t| t.join }
    result
  end

  def pselect(n = nil, &b)
    pool ||= $peach_default_threads || count
    raise "Thread pool size less than one?" unless pool >= 1
    div = (count/pool).to_i      # should already be integer
    div = 1 unless div >= 1     # each thread better do something!
    threads, results, result = [],[],[]

    each_slice(div).with_index do |slice, idx|
      threads << Thread.new(slice){|thread_slice| results[idx] = slice.select(&b)}
    end
    threads.each {|t| t.join }
    results.each {|x| result += x if x}
    result
  end

end

Array.send(:include, Peach)
