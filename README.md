hbasegate
=========

JRuby gem wrapping Java API for HBase

## Installation

Add this line to your application's Gemfile:

    gem 'hbasegate'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hbasegate

## Usage

Require the gem

    $ require 'hbasegate'

Create your configuration. This is optional since you can also define the config in a hbase-site.xml file as
shown in <a href"http://hbase.apache.org/book/config.files.html#client_dependencies">the hbase book</a>. The
minimal configuration is the specification of one or more ZooKeeper servers. This is used to find the HBase
API.

    $ config = HBaseGate::HBaseConfiguration.create
    $ config['hbase.zookeeper.quorum'] = 'zk1.test.com, zk2.test.com'

Get a handle to the table:

    $ table = HBaseGate::HTable.new(config, 'test_db')

And use it:

    $ r = table.get('me')
    $ puts r

You specify column families, columns and values in an array of arrays. Each element of the inner array specifies on
item.

    $ r = table.get('me', [['family']])
    $ r = table.get('me', [['family', 'column']])
    $ r = table.get('me', [['family1', 'column1'], ['family2', 'column2']])
    $ r = table.put('me', [['family1', 'column1', 'value1'], ['family2', 'column2', 'value2']])
    $ r = table.delete('me')
    $ r = table.delete('me', [['family']])
    $ r = table.delete('me', [['family', 'column']])



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
