class Array
  def peach(n = nil, &b)
    peachrun(:each, b, n)
  end
  def pmap(n = nil, &b)
    peachrun(:map, b, n)
  end
  def pdelete_if(n = nil, &b)
    peachrun(:delete_if, b, n)
  end

  protected
  def peachrun(meth, b, n = nil)
    threads, results, result = [],[],[]
    divvy(n).each_with_index do |x,i|
      if x.size > 0
        threads << Thread.new { results[i] = x.send(meth, &b)}
      else
        results[i] = []
      end
    end
    threads.each {|t| t.join }
    results.each {|x| result += x}
    result
  end
  
  def divvy(n = nil)
    n ||= size
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
