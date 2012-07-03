# monkey patch Enumerable by reopening it. Enumerable.send(:include, Peach) 
# doesn't seem to work as it should.  
module Peach
  class EmptyThreadPoolError < RuntimeError
  end
end

module Enumerable
  def _peach_run(pool = nil, &b)
    pool ||= $peach_default_threads || count
    unless pool >= 1
      raise Peach::EmptyThreadPoolError, "Thread pool size less than one"
    end
    div = (count/pool).to_i # should already be integer
    div = 1 unless div >= 1 # each thread better do something!

    threads = []
    each_slice(div).with_index do |slice, idx|
      threads << Thread.new(slice) do |thread_slice|
        yield thread_slice, idx, div
      end
    end
    threads.each{|t| t.join }
    self
  end

  def peach(pool = nil, &b)
    _peach_run(pool) do |thread_slice, idx, div|
      thread_slice.each{|elt| yield elt}
    end
  end

  def pmap(pool = nil, &b)
    result = Array.new(count)
    lock = Mutex.new

    _peach_run(pool) do |thread_slice, idx, div|
      thread_slice.each_with_index do |elt, offset| 
        local_result = yield elt
        lock.synchronize do
          result[(idx*div)+offset] = local_result
        end
      end
    end
    result
  end

  def pselect(pool = nil, &b)
    results, result = [],[]
    lock = Mutex.new

    _peach_run(pool) do |thread_slice, idx, div|
      local_result = thread_slice.select(&b)
      lock.synchronize do
        results[idx] = local_result
      end
    end
    results.each {|x| result += x if x}
    result
  end
end
