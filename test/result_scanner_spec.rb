require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/hbasegate'
require_relative 'fake_scanner'

describe HBaseGate::ResultScanner do
  describe '#next' do
    it 'iterates over all elements in the scanner' do
      scanner = FakeScanner.new(%w(a b c))
      scanner.next.must_equal 'a'
      scanner.next.must_equal 'b'
      scanner.next.must_equal 'c'
      scanner.next.must_equal nil
    end
  end

  describe '#each' do
    it 'iterates over all elements in the scanner' do
      scanner = FakeScanner.new(%w(a b c))
      scanner.entries.must_equal %w(a b c)
    end
  end
end

