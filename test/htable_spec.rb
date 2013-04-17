require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/hbasegate'

class HBaseGate::Get
  def to_h
    self
  end
end

describe HBaseGate::HTable do
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
      table.put('a', [['b', 'c', 'd']])
      expected = HBaseGate::Put.new('a'.to_java_bytes)
      expected.add('b'.to_java_bytes, 'c'.to_java_bytes, 'd'.to_java_bytes)
      result = table.get_write_buffer
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
      expected = HBaseGate::Get.new('a'.to_java_bytes)
      my_table.get('a').must_equal expected
    end

    it 'reads a specific column' do
      expected = HBaseGate::Get.new('a'.to_java_bytes)
      expected.add_column('b'.to_java_bytes, 'c'.to_java_bytes)
      my_table.get('a', [['b', 'c']]).must_equal expected
    end

    it 'reads a complete column family' do
      expected = HBaseGate::Get.new('a'.to_java_bytes)
      expected.add_family('b'.to_java_bytes)
      my_table.get('a', [['b']]).must_equal expected
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
      expected = HBaseGate::Delete.new('a'.to_java_bytes)
      my_table.delete('a')
      my_table.action.must_equal expected
    end

    it 'deletes a specific column' do
      expected = HBaseGate::Delete.new('a'.to_java_bytes)
      expected.delete_column('b'.to_java_bytes, 'c'.to_java_bytes)
      my_table.delete('a', [['b', 'c']])
      my_table.action.must_equal expected
    end

    it 'deletes a complete column family' do
      expected = HBaseGate::Delete.new('a'.to_java_bytes)
      expected.delete_family('b'.to_java_bytes)
      my_table.delete('a', [['b']])
      my_table.action.must_equal expected
    end
  end
end