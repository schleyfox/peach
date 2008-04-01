module Peach

  def peach(n = nil, &b)
    peachrun(:each, b, n)
  end
  def pmap(n = nil, &b)
    peachrun(:map, b, n)
  end
  def pdelete_if(n = nil, &b)
    peachrun(:delete_if, b, n)
  end

#  protected
  def peachrun(meth, b, n = nil)
    threads = []
    results = []
    divvy(n).each_with_index do |x,i|
      threads << Thread.new do
        results[i] = x.send(meth, &b)    
      end
    end
    threads.each {|t| t.join}
    result = []
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

class Array
  include Peach
end
