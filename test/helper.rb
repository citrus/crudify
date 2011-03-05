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
require "selenium/webdriver"

Capybara.default_driver = :selenium

# Run any available migrations
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)



# Include capybara and some extras into rails tests
module ActionController
  class IntegrationTest
    
    # turn off transactions for sqlite
    self.use_transactional_fixtures = false
    
    include Capybara
    
    def assert_seen(text, opts={})
      if opts[:within]
        within(selector_for(opts[:within])) do
          assert page.has_content?(text)
        end
      else
        assert page.has_content?(text)
      end
    end
    
    def assert_flash(key, text)
      within("#flash_#{key}") do
        assert_seen(text)
      end
    end
    
  end
end