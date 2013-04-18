module HBaseGate
  java_import 'org.apache.hadoop.hbase.client.Scan'

  module ResultScanner
    include Enumerable
    def each
      until (result = self.next).nil? do yield result end
    end
  end
end


