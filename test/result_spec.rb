require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/hbasegate'

java_import 'org.apache.hadoop.hbase.KeyValue'

describe HBaseGate::Result do
  ROW_KEY = 'a'
  FAMILY = 'b'
  QUALIFIER_1 = 'c'
  QUALIFIER_2 = 'e'
  VALUE_1 = 'd'
  VALUE_2 = 'f'
  COLUMN_1 = "#{FAMILY}:#{QUALIFIER_1}"
  COLUMN_2 = "#{FAMILY}:#{QUALIFIER_2}"

  describe '#to_h' do
    result = HBaseGate::Result.new(
        [
            KeyValue.new(ROW_KEY.to_java_bytes, FAMILY.to_java_bytes, QUALIFIER_1.to_java_bytes, VALUE_1.to_java_bytes),
            KeyValue.new(ROW_KEY.to_java_bytes, FAMILY.to_java_bytes, QUALIFIER_2.to_java_bytes, VALUE_2.to_java_bytes)
        ])
    actual = result.to_h
    it 'returns a hash' do
      actual.class.must_equal Hash
    end

    it 'has a column c in the family b' do
      actual.has_key?(COLUMN_1).must_equal true
    end

    it 'has a column e in the family b' do
      actual.has_key?(COLUMN_2).must_equal true
    end

    it 'has a value d for column c in family b' do
      actual[COLUMN_1].must_equal VALUE_1
    end

    it 'has a value f for column e in family b' do
      actual[COLUMN_2].must_equal VALUE_2
    end
  end
end

