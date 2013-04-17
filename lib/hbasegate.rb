require 'java'

$: << File.dirname(__FILE__)

require 'commons-configuration-1.6'
require 'commons-lang-2.5'
require 'commons-logging-1.1.1'
require 'guava-11.0.2'
require 'hadoop-auth'
require 'hadoop-common'
require 'hbase'
require 'slf4j-api-1.6.1.jar'
require 'zookeeper-3.4.5'

require 'hbasegate/hbase_configuration'
require 'hbasegate/htable'
require 'hbasegate/result'
require 'hbasegate/result_scanner'
require 'hbasegate/version'

$:.pop