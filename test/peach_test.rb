require File.join(File.dirname(__FILE__), "test_helper")

require File.join(File.dirname(__FILE__), "..", "lib", "peach")

class PeachTest < Test::Unit::TestCase
  [:peach, :pmap, :pselect].each do |f|
    context "Parallel function #{f}" do
      normal_f = f.to_s[1..-1].to_sym

      setup do
        @data = [1, 2, 3, 5, 8]
        @block = lambda{|i| i**2}
      end
      should "return the same result as #{normal_f}" do
        assert_equal @data.send(normal_f, &@block),
          @data.send(f, nil, &@block)
      end
    end
  end

  context "divvy" do
    setup do
      @data = [1, 2, 3, 4, 5]
    end

    context "on empty list" do
      should "return empty list" do
        assert_equal [], [].send(:peach_divvy)
      end
    end

    context "when n is nil" do
      should "put 1 element into each division" do
        assert_equal @data.size, @data.send(:peach_divvy).size
      end
    end

    context "when n is less than array size" do
      should "put create n divisions" do
        assert_equal 2, @data.send(:peach_divvy, 2).size
      end

      should "not lose any array elements" do
        assert_equal @data.size, @data.send(:peach_divvy, 2).inject(0) {|sum, i| 
          sum + i.size
        }
      end
    end
    
    context "when n is greater than array size" do
      should "only create 'array size' divisions" do
        assert_equal @data.size, @data.send(:peach_divvy, 42).size
      end
    end
  end
end
