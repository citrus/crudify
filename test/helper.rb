# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "shoulda"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
require 'watir'
require "safariwatir"

module Watir
  module Container
  
    class HiddenField < TextField
      def input_type; "hidden"; end
    end
    
    def hidden_field(how, what)
      HiddenField.new(self, scripter, how, what)
    end
    
  end
end


#Capybara.default_driver   = :watir
Capybara.default_selector = :css

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }




#require 'bundler/setup'

#
#require 'shoulda'
#require 'crudify'
#
##Bundler.require(:default, :development) if defined?(Bundler)
#
#
#class Jelly < ActiveRecord::Base
#  cattr_reader :per_page
#  @@per_page = 2
#end
#
#
##require 'crudify'
#
#
#db = File.expand_path('../db/test.sqlite3', __FILE__)
#File.delete(db) if File.exists?(db)
#
#
#config = { 'adapter' => 'sqlite3', 'database' => 'test/db/test.sqlite3' }
#sql = 'CREATE TABLE "jellies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "name" varchar(255), "created_at" datetime, "updated_at" datetime)'
#ActiveRecord::Base.establish_connection(config)
#ActiveRecord::Base.connection.execute(sql)
#
#
#["blackberry", "blueberry", "strawberry"].each do |jelly|
#  Jelly.create(:title => "#{jelly.capitalize} Jelly", :name => jelly)
#end
#
#
#class CrudifyTestController < ActionController::Base  
#  crudify :jelly  
#end