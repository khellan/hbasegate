module HBaseGate
  java_import 'org.apache.hadoop.hbase.client.Result'

  class Result
    # Return a nested hash of the result.
    def to_h
      get_no_version_map.entry_set.reduce({}) do |families, family_entries|
        columns = family_entries.get_value.entry_set.reduce({}) do |columns, column_entry|
          columns.update(
              String.from_java_bytes(column_entry.get_key) => String.from_java_bytes(column_entry.get_value))
        end
        families.update(String.from_java_bytes(family_entries.get_key) =>  columns)
      end
    end
  end
end
