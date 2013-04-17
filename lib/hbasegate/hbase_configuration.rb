module HBaseGate
  java_import 'org.apache.hadoop.conf.Configuration'
  java_import 'org.apache.hadoop.hbase.HBaseConfiguration'

  class Configuration
    # Retrieve the value stored for name.
    def [](name)
      get(name)
    end

    # Store value for name.
    def []=(name, value)
      set(name, value)
    end
  end
end