module Peach
  def peach(n = nil, &b)
    peach_run(:each, b, n)
  end

  def pmap(n = nil, &b)
    peach_run(:map, b, n)
  end

  def pselect(n = nil, &b)
    peach_run(:select, b, n)
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
