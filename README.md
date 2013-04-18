hbasegate
=========

JRuby gem wrapping Java API for HBase

(Use hbase-stargate for other ruby implementations)

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
    $ puts r.to_h

You specify column families and qualifiers as colon separated strings. When writing, you supply a hash of
columns to values and when reading, you specify an array of columns.

    $ r = table.get('me', ['family'])
    $ r = table.get('me', ['family:qualifier'])
    $ r = table.get('me', ['family1:qualifier1', 'family2:qualifier2'])
    $ table.put('me', { 'family1:column1' => 'value1', 'family2:column2' => 'value2' })
    $ r = table.delete('me')
    $ r = table.delete('me', ['family'])
    $ r = table.delete('me', ['family:qualifier'])

The to_h method of the result is useful for getting a hash of the result.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
