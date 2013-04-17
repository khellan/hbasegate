require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/hbasegate'

java_import 'org.apache.hadoop.hbase.KeyValue'

describe HBaseGate::Result do
  describe '#to_h' do
    result = HBaseGate::Result.new(
        [
            KeyValue.new('a'.to_java_bytes, 'b'.to_java_bytes, 'c'.to_java_bytes, 'd'.to_java_bytes),
            KeyValue.new('a'.to_java_bytes, 'b'.to_java_bytes, 'e'.to_java_bytes, 'f'.to_java_bytes)
        ])
    actual = result.to_h
    it 'returns a hash' do
      actual.class.must_equal Hash
    end

    it 'has family b' do
      actual.has_key?('b').must_equal true
    end

    it 'has a column c in the family b' do
      actual['b'].has_key?('c').must_equal true
    end

    it 'has a column e in the family b' do
      actual['b'].has_key?('e').must_equal true
    end

    it 'has a value d for column c in family b' do
      actual['b']['c'].must_equal 'd'
    end

    it 'has a value f for column e in family b' do
      actual['b']['e'].must_equal 'f'
    end
  end
end

