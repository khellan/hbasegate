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

    # Read row key with an array of family, column arrays.
    def get(key, entries = nil)
      get = Get.new(key.to_java_bytes)
      augment_action(entries, get.method(:add_family), get.method(:add_column))
      original_get(get).to_h
    end

    # Store row key with an array of family, column, value arrays.
    def put(key, entries = nil)
      put = Put.new(key.to_java_bytes)
      (entries || []).each.each do |family, qualifier, value|
        put.add(family.to_java_bytes, qualifier.to_java_bytes, value.to_java_bytes)
      end
      original_put(put)
    end

    # Delete row key with an array of family, column arrays.
    def delete(key, entries = nil)
      delete = Delete.new(key.to_java_bytes)
      augment_action(entries, delete.method(:delete_family), delete.method(:delete_column))
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
    # Iterate over the entries and use the given functions on them.
    def augment_action(entries, family_do, qualifier_do)
      (entries || []).each do |family, qualifier|
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
