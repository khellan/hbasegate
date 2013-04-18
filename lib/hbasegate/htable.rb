module HBaseGate
  java_import 'org.apache.hadoop.hbase.client.Delete'
  java_import 'org.apache.hadoop.hbase.client.Get'
  java_import 'org.apache.hadoop.hbase.client.HTable'
  java_import 'org.apache.hadoop.hbase.client.Put'
  java_import 'org.apache.hadoop.hbase.client.Scan'

  class HTable
    alias_method :original_delete, :delete
    alias_method :original_get, :get
    alias_method :original_put, :put
    alias_method :original_get_scanner, :get_scanner

    # Read row key with an optional array of columns.
    def get(key, entries = nil)
      get = Get.new(key.to_java_bytes)
      specify_columns(entries, get.method(:add_family), get.method(:add_column))
      original_get(get)
    end

    # Store row key with an hash of columns to values.
    def put(key, column_values = nil)
      put = Put.new(key.to_java_bytes)
      (column_values || {}).each do |column, value|
        family, qualifier = column.split(/:/)
        put.add(family.to_java_bytes, qualifier.to_java_bytes, value.to_java_bytes)
      end
      original_put(put)
    end

    # Delete row key with an optional array of columns.
    def delete(key, columns = nil)
      delete = Delete.new(key.to_java_bytes)
      specify_columns(columns, delete.method(:delete_family), delete.method(:delete_column))
      original_delete(delete)
    end

    # Create a scanner for the table.
    def get_scanner(start_row = nil, stop_row = nil)
      scan = case
        when stop_row
          Scan.new(start_row.to_java_bytes, stop_row.to_java_bytes)
        when start_row
          Scan.new(start_row.to_java_bytes)
        else
          Scan.new
      end
      original_get_scanner(scan)
    end

    private
    # Iterate over the columns and use the given functions on them.
    def specify_columns(columns, family_do, qualifier_do)
      (columns || []).each do |column|
        family, qualifier = column.split(/:/)
        case
          when qualifier
            qualifier_do.call(family.to_java_bytes, qualifier.to_java_bytes)
          when family
            family_do.call(family.to_java_bytes)
        end
      end
    end
  end
end
