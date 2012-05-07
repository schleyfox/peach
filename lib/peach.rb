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



  protected
  def peach_run(meth, b, n = nil)
    threads, results, result = [],[],[]
    peach_divvy(n).each_with_index do |x,i|
      threads << Thread.new { results[i] = x.send(meth, &b)}
    end
    threads.each {|t| t.join }
    results.each {|x| result += x if x}
    result
  end
  
  def peach_divvy(n = nil)
    return [] if size == 0

    n ||= $peach_default_threads || size
    n = size if n > size

    lists = []

    div = (size/n).floor
    offset = 0
    for i in (0...n-1)
      lists << slice(offset, div)
      offset += div
    end
    lists << slice(offset...size)
    lists
  end
end

Array.send(:include, Peach)
