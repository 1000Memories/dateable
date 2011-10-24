# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
ROOT       = File.join(File.dirname(__FILE__), '..')
RAILS_ROOT = ROOT
$LOAD_PATH << File.join(ROOT, 'lib')

require "rails/test_help"
require 'shoulda/rails'
require 'sqlite3'
require 'active_record'

require 'dateable'

ENV['RAILS_ENV'] ||= 'test'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# rebuild_model and rebuild_class are borrowed directly from the Paperclip gem
# (actually via the StrongBox gem)
#
# http://thoughtbot.com/projects/paperclip


# rebuild_model (re)creates a database table for our Dummy model.
# Call this to initial create a model, or to reset the database.

def rebuild_model options = {}
  ActiveRecord::Base.connection.create_table :dummies, :force => true do |table|
    table.datetime :date
    table.string   :date_string
    table.integer  :date_specificity
  end
  rebuild_class options
end

# rebuild_class creates or replaces the Dummy ActiveRecord Model.
# Call this when changing the options to encrypt_with_public_key

def rebuild_class options = {}
  ActiveRecord::Base.send(:include, Dateable)
  Object.send(:remove_const, "Dummy") rescue nil
  Object.const_set("Dummy", Class.new(ActiveRecord::Base))
  Dummy.class_eval do
    include Dateable
    dateable_field :date, options
  end
  Dummy.reset_column_information
end

