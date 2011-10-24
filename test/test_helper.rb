# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'dateable'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'matchy'
require "rails/test_help"
require 'sqlite3'
require 'active_record'

require 'shoulda/rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# rebuild_model and rebuild_class are borrowed directly from the Paperclip gem
# (actually via the StrongBox gem)
#
# http://thoughtbot.com/projects/paperclip


# rebuild_model (re)creates a database table for our Dummy model.
# Call this to initial create a model, or to reset the database.

def rebuild_model
  ActiveRecord::Base.connection.create_table :dummies, :force => true do |table|
    table.datetime :date
    table.string   :date_string
    table.integer  :date_specificity
  end
  rebuild_class
end

# rebuild_class creates or replaces the Dummy ActiveRecord Model.
# Call this when changing the options to encrypt_with_public_key

def rebuild_class
  ActiveRecord::Base.send(:include, Dateable)
  Object.send(:remove_const, "Dummy") rescue nil
  Object.const_set("Dummy", Class.new(ActiveRecord::Base))
  Dummy.class_eval do
    extend Dateable
    has_dateable_field :date
  end
  Dummy.reset_column_information
end

