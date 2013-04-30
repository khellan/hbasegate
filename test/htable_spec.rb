require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/hbasegate'
require_relative 'fake_scanner'

java_import 'org.apache.hadoop.hbase.HConstants'

class HBaseGate::Get
  def to_h
    self
  end
end

describe HBaseGate::HTable do
  ROW_KEY = 'a'
  FAMILY = 'b'
  COLUMN = 'c'
  VALUE = 'd'
  FULL_COLUMN_NAME = "#{FAMILY}:#{COLUMN}"

  table = HBaseGate::HTable.new(nil, 't')
  table.set_write_buffer_size(2097152)

  describe '#get_write_buffer_size' do
    it 'has default value' do
      table.get_write_buffer_size.must_equal 2097152
    end
  end

  describe '#original_put' do
    it 'responds to original put' do
      table.respond_to?(:original_put).must_equal true
    end
  end

  describe '#put' do
    it 'writes to the table' do
      my_table = HBaseGate::HTable.new(nil, 't')
      my_table.set_write_buffer_size(2097152)
      my_table.put('a', { FULL_COLUMN_NAME => VALUE })
      expected = HBaseGate::Put.new(ROW_KEY.to_java_bytes)
      expected.add(FAMILY.to_java_bytes, COLUMN.to_java_bytes, VALUE.to_java_bytes)
      result = my_table.get_write_buffer
      result.get(0).must_equal expected
      result.size.must_equal 1
    end

    it 'handles numeric values' do
      my_table = HBaseGate::HTable.new(nil, 't')
      my_table.set_write_buffer_size(2097152)
      my_table.put('a', { FULL_COLUMN_NAME => 1 })
      expected = HBaseGate::Put.new(ROW_KEY.to_java_bytes)
      expected.add(FAMILY.to_java_bytes, COLUMN.to_java_bytes, 1.to_s.to_java_bytes)
      result = my_table.get_write_buffer
      result.get(0).must_equal expected
      result.size.must_equal 1
    end
  end

  describe '#original_get' do
    it 'responds to original get' do
      table.respond_to?(:original_get).must_equal true
    end
  end

  describe '#get' do
    my_table = table.dup
    def my_table.original_get(get)
      get
    end
    it 'reads a full row' do
      expected = HBaseGate::Get.new(ROW_KEY.to_java_bytes)
      my_table.get(ROW_KEY).must_equal expected
    end

    it 'reads a specific column' do
      expected = HBaseGate::Get.new(ROW_KEY.to_java_bytes)
      expected.add_column(FAMILY.to_java_bytes, COLUMN.to_java_bytes)
      my_table.get(ROW_KEY, [FULL_COLUMN_NAME]).must_equal expected
    end

    it 'reads a complete column family' do
      expected = HBaseGate::Get.new(ROW_KEY.to_java_bytes)
      expected.add_family(FAMILY.to_java_bytes)
      my_table.get(ROW_KEY, [FAMILY]).must_equal expected
    end
  end

  describe '#original_delete' do
    it 'responds to original delete' do
      table.respond_to?(:original_delete).must_equal true
    end
  end

  describe '#delete' do
    my_table = table.dup
    def my_table.original_delete(delete)
      @action = delete
    end
    def my_table.action
      @action
    end
    it 'deletes a full row' do
      expected = HBaseGate::Delete.new(ROW_KEY.to_java_bytes)
      my_table.delete(ROW_KEY)
      my_table.action.must_equal expected
    end

    it 'deletes a specific column' do
      expected = HBaseGate::Delete.new(ROW_KEY.to_java_bytes)
      expected.delete_column(FAMILY.to_java_bytes, COLUMN.to_java_bytes)
      my_table.delete(ROW_KEY, [FULL_COLUMN_NAME])
      my_table.action.must_equal expected
    end

    it 'deletes a complete column family' do
      expected = HBaseGate::Delete.new(ROW_KEY.to_java_bytes)
      expected.delete_family(FAMILY.to_java_bytes)
      my_table.delete(ROW_KEY, [FAMILY])
      my_table.action.must_equal expected
    end
  end

  describe '#get_scanner' do
    my_table = table.dup
    def my_table.original_get_scanner(scan)
      scan
    end
    it 'yields a scanner for the whole table' do
      actual = my_table.get_scanner
      actual.get_start_row.must_equal HConstants::EMPTY_START_ROW
      actual.get_stop_row.must_equal HConstants::EMPTY_END_ROW
    end

    it 'yields a scanner with a start row' do
      actual = my_table.get_scanner('a')
      String.from_java_bytes(actual.get_start_row).must_equal 'a'
      actual.get_stop_row.must_equal HConstants::EMPTY_END_ROW
    end

    it 'yields a scanner with a start row' do
      actual = my_table.get_scanner('a', 'z')
      String.from_java_bytes(actual.get_start_row).must_equal 'a'
      String.from_java_bytes(actual.get_stop_row).must_equal 'z'
    end
  end

  describe '#each' do
    my_table = table.dup
    def my_table.original_get_scanner(_)
      FakeScanner.new(%w(a b c))
    end
    it 'iterates over all elements in the table through the scanner' do
      my_table.entries.must_equal %w(a b c)
    end
  end
end