# lib/chef-handler-influxdb.rb
#
# Author: Simple Finance <ops@simple.com>
# Copyright 2013 Simple Finance Technology Corporation.
# Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Chef handler to add Chef run and optional user data to InfluxDB

require 'rubygems'
require 'chef'
require 'chef/handler'
require 'influxdb'

class ChefInfluxDB < Chef::Handler
    attr_reader :host, :port, :user, :pass, :database, :series, :data

    def initialize(options = defaults)
      @database = options[:database]
      @series = options[:series]
      @host = options[:host]
      @port = options[:port]
      @user = options[:user]
      @pass = options[:pass]
      @data = options[:data]
    end

    def defaults
      return {
        :user => 'root',
        :pass => 'root',
        :host => 'localhost',
        :port => 8086,
        :database => nil,
        :series => nil
      }
    end

    def client
      return InfluxDB::Client.new(
        @database,
        :host => @host,
        :port => @port,
        :username => @user,
        :password => @pass
      )
    end

    def generate_data
      return {
        :host => node.name,
        :status => run_status.success? ? 1 : 0,
        :resources_updated => run_status.updated_resources.length,
        :elapsed_time => run_status.elapsed_time,
        :end_time => Time.now.to_s
      }.merge(@data || {})
    end

    def report
      Chef::Log.info 'Exporting Chef run data to InfluxDB'
      client.write_point(@series, {values: generate_data})
    end

end
