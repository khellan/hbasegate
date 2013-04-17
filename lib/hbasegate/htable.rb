module HBaseGate
  java_import 'org.apache.hadoop.hbase.client.Delete'
  java_import 'org.apache.hadoop.hbase.client.Get'
  java_import 'org.apache.hadoop.hbase.client.HTable'
  java_import 'org.apache.hadoop.hbase.client.Put'

  class HTable
    alias_method :original_delete, :delete
    alias_method :original_get, :get
    alias_method :original_put, :put

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
