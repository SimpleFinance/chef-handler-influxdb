Gem::Specification.new do |s|
  s.name = 'chef-handler-influxdb'
  s.version = '0.1.4'
  s.author = 'Simple Finance'
  s.email = 'ops@simple.com'
  s.homepage = 'http://github.com/SimpleFinance/chef-handler-influxdb'
  s.summary = 'Updates InfluxDB with Chef run data'
  s.description = 'Updates InfluxDB with Chef run and arbitrary user data'
  s.files = ::Dir.glob('**/*')
  s.require_paths = ['lib']
end

