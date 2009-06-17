# ETL: Extract, Transform, Load
# This module is a simple ETL derived from existing code in another (personal) project 
# for turning data residing in existing tables into YML files or 
# loading YML files into the database.
#
# Much of this code was taken from the rails tasks themselves and adapted herein.
#
# Author: Michael Lang, mwlang@cybrains.net
# 
# Freely donated to the Spree project to fall under Spree's LICENSE 
#
namespace :db do 
  namespace :etl do
    desc 'Dump the database to RAILS_ROOT/db/#{FIXTURE}'
    task :dump => :environment do
      fixture   = ENV['FIXTURE']   || 'default'
      path = ENV['DEST'] || "#{RAILS_ROOT}/db/#{fixture}"
      database_to_yaml(fixture, path, ENV['TABLE'] || ENV['TABLES'], ENV['LIMIT'], ENV['WHERE'])
    end

    desc 'Loads the fixtures from RAILS_ROOT/db/#{FIXTURE}'
    task :load => :environment do
      fixture   = ENV['FIXTURE']   || 'default'
      path = ENV['DEST'] || "#{RAILS_ROOT}/db/#{fixture}"
      yaml_to_database(fixture, path)
    end
  end # etl
end # db

def database_to_yaml(fixture, path, tables, limit, where)
  sql  = "SELECT * FROM table_name"
  sql += " where #{where}" unless where.nil?
  sql += " limit #{limit}" unless limit.nil?
  if tables.nil?
    table_list = ActiveRecord::Base.connection.tables
  else
    table_list = tables.split(',')
  end
  FileUtils.mkdir_p(path)
  ActiveRecord::Base.establish_connection(RAILS_ENV)
  table_list.each do |table_name|
    puts "exporting #{table_name}.yml..."
    i = '000'
    File.open("#{path}/#{table_name}.yml", 'wb') do |file|
      file.write ActiveRecord::Base.connection.select_all(sql.gsub("table_name", table_name)).inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml
    end
  end
end

def yaml_to_database(fixture, path)
  require 'active_record/fixtures'
  ActiveRecord::Base.establish_connection(RAILS_ENV)
  tables = Dir.new(path).entries.select{|e| e =~ /(.+)?\.yml/}.collect{|c| c.split('.').first}
  Fixtures.create_fixtures(path, tables)
end
