# ChefInfluxDB handler
A Chef handler to update InfluxDB with data from the most recent Chef run. By
default, it will report on:

* Run status (success/fail)
* Number of updated resources
* Elapsed time
* Time the Chef run approximately ended

You can also ship arbitrary data into InfluxDB using the `data` argument. Be
warned, however, that this is somewhat sensitive to timing, as all data must be
finalized before being passed into the handler. In otherwords, if you pass in
an attribute and then change its value after declaring the handler, you will
see the previous/initial value.

At least the `:database` and `:series` arguments are required. The handler
otherwise assumes an InfluxDB server on localhost:8086, with credentials of
`root:root` (defaults for InfluxDB).

## Prerequisites
The `influxdb` Rubygem as well as an InfluxDB server setup somewhere. Install the gem
using the following:

```ruby
chef_gem 'influxdb' do
  action :nothing
end.run_action(:install)
```

## Usage
Either just pull the handler file into the files/ directory of one of your
cookbooks, or download as a Rubygem and source it that way.

```ruby
# Option 1
cookbook_file "#{node[:chef_handler][:handler_path]}/chef-handler-influxdb.rb" do
  source 'chef-handler-influxdb.rb'
  mode 00600
end

chef_handler 'ChefInfluxDB' do
  source "#{node[:chef_handler][:handler_path]}/chef-handler-influxdb.rb"
  arguments [
    :database => 'database',
    :series => 'my_series',
    :data => node[:cookbook][:attribute].to_hash,
  ]
  action :enable
end

# Option 2
chef_gem 'chef-handler-influxdb' do
  action :install
end

chef_handler 'ChefInfluxDB' do
  source ::File.join(Gem::Specification.find_by_name('chef-handler-influxdb').lib_dirs_glob,
                     'chef-handler-influxdb.rb')
  arguments [
    :database => 'database',
    :series => 'my_series',
    :data => node[:cookbook][:attribute].to_hash,
  ]
  action :enable
end
```

### Arguments
* `database` - The database to connect to (required)
* `series` - The timeseries to write to (required)
* `host` - The host of the InfluxDB server (default: `localhost`)
* `port` - The port of the InfluxDB server (default: `8086`)
* `user` - The user to connect as (default: `root`)
* `pass` - The password to authenticate with (default: `root`)
* `data` - Send arbitrary data to InfluxDB (default: `{}`)

## Questions?
Hop on `##simple` on Freenode with any questions or concerns.

## Author and License
Simple Finance \<<ops@simple.com>\>

Apache License, Version 2.0

