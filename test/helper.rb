begin
  require 'rubygems'
  require 'bundler/setup'
	require 'rails/all'
  require 'shoulda'
	require 'crudify'
  require 'will_paginate'
	#require 'sqlite3'
rescue LoadError => e
	puts "Load error!"
	puts e.inspect
	exit
end


class Jelly < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 2
end

db = File.expand_path('../db/test.sqlite3', __FILE__)
`rm #{db}` if File.exists?(db)

config = { 'adapter' => 'sqlite3', 'database' => 'test/db/test.sqlite3' }
sql = 'CREATE TABLE "jellies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "name" varchar(255), "created_at" datetime, "updated_at" datetime)'
ActiveRecord::Base.establish_connection(config)
ActiveRecord::Base.connection.execute(sql)


["blackberry", "blueberry", "strawberry"].each do |jelly|
  Jelly.create(:title => "#{jelly.capitalize} Jelly", :name => jelly)
end


class CrudifyTestController < ActionController::Base
    
  crudify :jelly
  
end

