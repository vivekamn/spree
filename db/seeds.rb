# load setup data from seeds
fixture = "default"
yaml_to_database(fixture, "#{RAILS_ROOT}/db/#{fixture}")

def yaml_to_database(fixture, path)
  require 'active_record/fixtures'
  ActiveRecord::Base.establish_connection(RAILS_ENV)
  tables = Dir.new(path).entries.select{|e| e =~ /(.+)?\.yml/}.collect{|c| c.split('.').first}
  Fixtures.create_fixtures(path, tables)
end