require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/hbasegate'

describe HBaseGate::ResultScanner do
  class TestScanner
    include HBaseGate::ResultScanner
    def initialize(items)
      @items = items
      reset
    end

    def next
      return nil if @index >= @items.length
      @index += 1
      @items[@index]
    end

    def reset
      @index = -1
    end
  end

  describe '#next' do
    it 'iterates over all elements in the scanner' do
      scanner = TestScanner.new(%w(a b c))
      scanner.next.must_equal 'a'
      scanner.next.must_equal 'b'
      scanner.next.must_equal 'c'
      scanner.next.must_equal nil
    end
  end

  describe '#each' do
    it 'iterates over all elements in the scanner' do
      scanner = TestScanner.new(%w(a b c))
      scanner.entries.must_equal %w(a b c)
    end
  end
end

